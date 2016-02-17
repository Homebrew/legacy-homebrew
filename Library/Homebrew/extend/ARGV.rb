module HomebrewArgvExtension
  def named
    @named ||= self - options_only
  end

  def options_only
    select { |arg| arg.start_with?("-") }
  end

  def flags_only
    select { |arg| arg.start_with?("--") }
  end

  def formulae
    require "formula"
    @formulae ||= (downcased_unique_named - casks).map do |name|
      if name.include?("/") || File.exist?(name)
        Formulary.factory(name, spec)
      else
        Formulary.find_with_priority(name, spec)
      end
    end
  end

  def resolved_formulae
    require "formula"
    @resolved_formulae ||= (downcased_unique_named - casks).map do |name|
      if name.include?("/")
        f = Formulary.factory(name, spec)
        if spec(default=nil).nil? && f.any_version_installed?
          installed_spec = Tab.for_formula(f).spec
          f.set_active_spec(installed_spec) if f.send(installed_spec)
        end
        f
      else
        rack = Formulary.to_rack(name)
        Formulary.from_rack(rack, spec(default=nil))
      end
    end
  end

  def casks
    @casks ||= downcased_unique_named.grep HOMEBREW_CASK_TAP_FORMULA_REGEX
  end

  def kegs
    require "keg"
    require "formula"
    @kegs ||= downcased_unique_named.collect do |name|
      rack = Formulary.to_rack(name)

      dirs = rack.directory? ? rack.subdirs : []

      raise NoSuchKegError.new(rack.basename) if dirs.empty?

      linked_keg_ref = HOMEBREW_LIBRARY.join("LinkedKegs", rack.basename)
      opt_prefix = HOMEBREW_PREFIX.join("opt", rack.basename)

      begin
        if opt_prefix.symlink? && opt_prefix.directory?
          Keg.new(opt_prefix.resolved_path)
        elsif linked_keg_ref.symlink? && linked_keg_ref.directory?
          Keg.new(linked_keg_ref.resolved_path)
        elsif dirs.length == 1
          Keg.new(dirs.first)
        elsif (prefix = (name.include?("/") ? Formulary.factory(name) : Formulary.from_rack(rack)).prefix).directory?
          Keg.new(prefix)
        else
          raise MultipleVersionsInstalledError.new(rack.basename)
        end
      rescue FormulaUnavailableError
        raise <<-EOS.undent
          Multiple kegs installed to #{rack}
          However we don't know which one you refer to.
          Please delete (with rm -rf!) all but one and then try again.
        EOS
      end
    end
  end

  # self documenting perhaps?
  def include?(arg)
    @n=index arg
  end

  def next
    at(@n+1) || raise(UsageError)
  end

  def value(arg)
    arg = find { |o| o =~ /--#{arg}=(.+)/ }
    $1 if arg
  end

  def force?
    flag? "--force"
  end

  def verbose?
    flag?("--verbose") || !ENV["VERBOSE"].nil? || !ENV["HOMEBREW_VERBOSE"].nil?
  end

  def debug?
    flag?("--debug") || !ENV["HOMEBREW_DEBUG"].nil?
  end

  def quieter?
    flag? "--quieter"
  end

  def one?
    flag? "--1"
  end

  def dry_run?
    include?("--dry-run") || switch?("n")
  end

  def git?
    flag? "--git"
  end

  def homebrew_developer?
    !ENV["HOMEBREW_DEVELOPER"].nil?
  end

  def interactive?
    include?("--interactive")
  end

  def sandbox?
    include?("--sandbox") || !ENV["HOMEBREW_SANDBOX"].nil?
  end

  def no_sandbox?
    include?("--no-sandbox") || !ENV["HOMEBREW_NO_SANDBOX"].nil?
  end

  def ignore_deps?
    include? "--ignore-dependencies"
  end

  def only_deps?
    include? "--only-dependencies"
  end

  def json
    value "json"
  end

  def build_head?
    include? "--HEAD"
  end

  def build_devel?
    include? "--devel"
  end

  def build_stable?
    !(build_head? || build_devel?)
  end

  def build_universal?
    include? "--universal"
  end

  # Request a 32-bit only build.
  # This is needed for some use-cases though we prefer to build Universal
  # when a 32-bit version is needed.
  def build_32_bit?
    include? "--32-bit"
  end

  def build_bottle?
    include?("--build-bottle") || !ENV["HOMEBREW_BUILD_BOTTLE"].nil?
  end

  def bottle_arch
    arch = value "bottle-arch"
    arch.to_sym if arch
  end

  def build_from_source?
    switch?("s") || include?("--build-from-source") || !!ENV["HOMEBREW_BUILD_FROM_SOURCE"]
  end

  def flag?(flag)
    options_only.include?(flag) || switch?(flag[2, 1])
  end

  def force_bottle?
    include? "--force-bottle"
  end

  # eg. `foo -ns -i --bar` has three switches, n, s and i
  def switch?(char)
    return false if char.length > 1
    options_only.any? { |arg| arg[1, 1] != "-" && arg.include?(char) }
  end

  def usage
    require "cmd/help"
    Homebrew.help_s
  end

  def cc
    value "cc"
  end

  def env
    value "env"
  end

  # If the user passes any flags that trigger building over installing from
  # a bottle, they are collected here and returned as an Array for checking.
  def collect_build_flags
    build_flags = []

    build_flags << "--HEAD" if build_head?
    build_flags << "--universal" if build_universal?
    build_flags << "--32-bit" if build_32_bit?
    build_flags << "--build-bottle" if build_bottle?
    build_flags << "--build-from-source" if build_from_source?

    build_flags
  end

  private

  def spec(default = :stable)
    if include?("--HEAD")
      :head
    elsif include?("--devel")
      :devel
    else
      default
    end
  end

  def downcased_unique_named
    # Only lowercase names, not paths, bottle filenames or URLs
    @downcased_unique_named ||= named.map do |arg|
      if arg.include?("/") || arg.end_with?(".tar.gz")
        arg
      else
        arg.downcase
      end
    end.uniq
  end
end
