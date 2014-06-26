# Install a formula and dependencies from pre-made bottles or as built bottles.
#
# Useful for creating a portable Homebrew directory for a specific OS version.
# Example: portable domain-specific software stack in custom Homebrew prefix
#
# Hint: Use command in `brew bundle` Brewfiles to quickly build full stacks.
#       Also, --dry option helps create correctly ordered Brewfiles when you
#       want to use custom options for dependencies and build those first.

require "formula"
require "cmd/deps"
require "utils"
require "hooks/bottles"

def usage; <<-EOS
  Usage: brew stack [--dry] [--all] [options...] formula [formula-options...]

         Same options as for `brew install`, but only for a single formula.
         Note: --interactive install option is not supported

  Options: --dry  Don't install anything, just output topologically ordered list
                  of install commands.
           --all  List all dependencies, including installed, on --dry run.

  EOS
end


class Stack
  attr_reader :f, :opts, :argv, :dry, :all, :verbose

  # Variable to track what's been installed, to avoid endless loops with --dry.
  @@dry_installed = []
  @@first_run = true

  def initialize formula, options=[], argv=nil, dry=false, all=false, verbose=false
    @f = formula
    @opts = options
    @argv = argv
    @dry = dry
    @all = all
    @verbose = verbose
  end

  def tap_name(f_obj)
    (f_obj.tap? ? f_obj.tap.sub("homebrew-", "") + "/" : "") + f_obj.name
  end

  def to_tap_names(f_name_list)
    f_name_list.map do |f|
      begin
        tap_name(Formulary.factory(f))
      rescue FormulaUnavailableError
        next
      end
    end
  end

  def oohai title, *sput
    # don't truncate, like ohai
    puts "#{Tty.blue}==>#{Tty.white} #{title}#{Tty.reset}"
    puts sput unless sput.empty?
  end

  def ooh1 title
    # don't truncate, like oh1
    puts "#{Tty.green}==>#{Tty.white} #{title}#{Tty.reset}"
  end

  def owell title
    puts "#{Tty.gray}==>#{Tty.white} #{title}#{Tty.reset}"
  end

  def install
    # Install dependencies in topological order.
    # This is necessary to ensure --build-bottle is used for any source builds.
    f_build_opts = @f.build.used_options.as_flags
    unless @argv && @argv.ignore_deps?
      deps = Homebrew.deps_for_formula(@f, true) # recursive
      deps = deps.reject { |d| d.installed? } unless @dry && @all
      deps = deps.reject { |d| @@dry_installed.include?(tap_name(d.to_formula)) } if @dry

      if @dry
        if @verbose && !f_build_opts.empty?
          oohai "Options used, #{@f.name}: #{f_build_opts.join(" ")}"
          oohai "Options unused, #{@f.name}: #{(@f.build.as_flags - f_build_opts).join(" ")}"
        end
        unless deps.empty?
          deps_w_opts = deps.map do |d|
            d.to_s + (d.options.empty? ? "" : " ") + d.options.as_flags.join(" ")
          end
          oohai "Deps needed, #{@f.name}: #{deps_w_opts.join(", ")}"
        end
        puts if @@first_run
      end
      @@first_run = false

      deps.each do |d|
        d_obj = d.to_formula
        d_args = []
        d_args.concat @opts - f_build_opts + d.options.as_flags
        # strip these options
        d_args -= %W[--ignore-dependencies --only-dependencies]
        d_args -= %W[--build-from-source --force-bottle --build-bottle]
        d_args -= %W[--devel --HEAD]
        # recurse down into dependencies, nixing argv
        Stack.new(d_obj, options=d_args, argv=nil, dry=@dry, all=@all, verbose=@verbose).install
      end unless deps.empty?
    end

    # Install formula
    unless @argv && @argv.only_deps?
      f_tap_name = tap_name(@f)
      if (@f.installed? && !(@dry && @all)) || (@dry && @@dry_installed.include?(f_tap_name))
        owell "#{f_tap_name} already installed"
      else
        f_args = []
        f_args.concat @opts
        if (@argv && @argv.build_from_source?) || !pour_bottle?(@f)
          f_args |= %W[--build-bottle]
        end
        attempt_install @f, f_args
      end
    end
  end

  def attempt_install f_obj, args
    f_tap_name = tap_name(f_obj)
    args -= %W[--dry --all --build-from-source]
    args << f_tap_name
    ooh1 "brew install #{args.join(" ")}"
    if @dry
      @@dry_installed += [f_tap_name]
      return
    end

    return if system "brew", "install", *args

    if args.include?("--build-bottle")
      odie "Source bottle build failed"
    else
      opoo "Bottle may have failed to install"
      ohai "Attempting to build bottle from source"
      args |= %W[--build-bottle]

      return if system "brew", "install", *args
      odie "Source bottle build failed"
    end
  end

  def pour_bottle? f
    # Culled from FormulaInstaller::pour_bottle?
    return true  if Homebrew::Hooks::Bottles.formula_has_bottle?(f)

    return true  if @argv && @argv.force_bottle? && f.bottle
    return false if @argv && (@argv.build_from_source? || @argv.build_bottle?)
    return false unless f.build.used_options.empty?

    return true  if f.local_bottle_path
    return false unless f.bottle && f.pour_bottle?

    f.requirements.each do |req|
      next if req.optional? || req.pour_bottle?
      opoo "Bottle for #{f} blocked by #{req} requirement"
      return false
    end

    unless f.bottle.compatible_cellar?
      opoo "Cellar of #{f}'s bottle is #{f.bottle.cellar}"
      return false
    end

    true
  end

end

# Necessary to raise error if bottle fails to install
ENV["HOMEBREW_DEVELOPER"] = "1"

if ARGV.formulae.length != 1 || ARGV.interactive?
  puts usage
  exit 1
end

if ARGV.include? "--help"
  puts usage
  exit 0
end

Stack.new(
    ARGV.formulae[0],
    options=ARGV.options_only,
    argv=ARGV,
    dry=ARGV.include?("--dry"),
    all=ARGV.include?("--all"),
    verbose=(ARGV.verbose? || ARGV.switch?("v"))
).install

puts "#{Tty.red}==>#{Tty.white} Dry Run#{Tty.reset}" if ARGV.include?("--dry")

exit 0
