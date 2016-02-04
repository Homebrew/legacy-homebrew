require "formula"
require "formula_versions"
require "utils"
require "extend/ENV"
require "formula_cellar_checks"
require "official_taps"
require "tap_migrations"
require "cmd/search"
require "date"
require "formula_renames"

module Homebrew
  def audit
    formula_count = 0
    problem_count = 0

    strict = ARGV.include? "--strict"
    if strict && ARGV.resolved_formulae.any? && RUBY_VERSION.split(".").first.to_i >= 2
      require "cmd/style"
      ohai "brew style #{ARGV.resolved_formulae.join " "}"
      style
    end

    online = ARGV.include? "--online"

    ENV.activate_extensions!
    ENV.setup_build_environment

    if ARGV.switch? "D"
      FormulaAuditor.module_eval do
        instance_methods.grep(/audit_/).map do |name|
          method = instance_method(name)
          define_method(name) do |*args, &block|
            begin
              time = Time.now
              method.bind(self).call(*args, &block)
            ensure
              $times[name] ||= 0
              $times[name] += Time.now - time
            end
          end
        end
      end

      $times = {}
      at_exit { puts $times.sort_by { |_k, v| v }.map { |k, v| "#{k}: #{v}" } }
    end

    ff = if ARGV.named.empty?
      Formula
    else
      ARGV.resolved_formulae
    end

    output_header = !strict

    ff.each do |f|
      fa = FormulaAuditor.new(f, :strict => strict, :online => online)
      fa.audit

      unless fa.problems.empty?
        unless output_header
          puts
          ohai "audit problems"
          output_header = true
        end

        formula_count += 1
        problem_count += fa.problems.size
        puts "#{f.full_name}:", fa.problems.map { |p| " * #{p}" }, ""
      end
    end

    unless problem_count.zero?
      problems = "problem" + plural(problem_count)
      formulae = "formula" + plural(formula_count, "e")
      ofail "#{problem_count} #{problems} in #{formula_count} #{formulae}"
    end
  end
end

class FormulaText
  def initialize(path)
    @text = path.open("rb", &:read)
    @lines = @text.lines.to_a
  end

  def without_patch
    @text.split("\n__END__").first
  end

  def has_DATA?
    /^[^#]*\bDATA\b/ =~ @text
  end

  def has_END?
    /^__END__$/ =~ @text
  end

  def has_trailing_newline?
    /\Z\n/ =~ @text
  end

  def =~(regex)
    regex =~ @text
  end

  def line_number(regex)
    index = @lines.index { |line| line =~ regex }
    index ? index + 1 : nil
  end
end

class FormulaAuditor
  include FormulaCellarChecks

  attr_reader :formula, :text, :problems

  BUILD_TIME_DEPS = %W[
    autoconf
    automake
    boost-build
    bsdmake
    cmake
    godep
    imake
    intltool
    libtool
    pkg-config
    scons
    smake
    sphinx-doc
    swig
  ]

  FILEUTILS_METHODS = FileUtils.singleton_methods(false).join "|"

  def initialize(formula, options = {})
    @formula = formula
    @strict = !!options[:strict]
    @online = !!options[:online]
    @problems = []
    @text = FormulaText.new(formula.path)
    @specs = %w[stable devel head].map { |s| formula.send(s) }.compact
  end

  def audit_file
    # Under normal circumstances (umask 0022), we expect a file mode of 644. If
    # the user's umask is more restrictive, respect that by masking out the
    # corresponding bits. (The also included 0100000 flag means regular file.)
    wanted_mode = 0100644 & ~File.umask
    actual_mode = formula.path.stat.mode
    unless actual_mode == wanted_mode
      problem format("Incorrect file permissions (%03o): chmod %03o %s",
                     actual_mode & 0777, wanted_mode & 0777, formula.path)
    end

    if text.has_DATA? && !text.has_END?
      problem "'DATA' was found, but no '__END__'"
    end

    if text.has_END? && !text.has_DATA?
      problem "'__END__' was found, but 'DATA' is not used"
    end

    unless text.has_trailing_newline?
      problem "File should end with a newline"
    end

    return unless @strict

    component_list = [
      [/^  desc ["'][\S\ ]+["']/,          "desc"],
      [/^  homepage ["'][\S\ ]+["']/,      "homepage"],
      [/^  url ["'][\S\ ]+["']/,           "url"],
      [/^  mirror ["'][\S\ ]+["']/,        "mirror"],
      [/^  version ["'][\S\ ]+["']/,       "version"],
      [/^  (sha1|sha256) ["'][\S\ ]+["']/, "checksum"],
      [/^  revision/,                      "revision"],
      [/^  head ["'][\S\ ]+["']/,          "head"],
      [/^  stable do/,                     "stable block"],
      [/^  bottle do/,                     "bottle block"],
      [/^  devel do/,                      "devel block"],
      [/^  head do/,                       "head block"],
      [/^  bottle (:unneeded|:disable)/,   "bottle modifier"],
      [/^  keg_only/,                      "keg_only"],
      [/^  option/,                        "option"],
      [/^  depends_on/,                    "depends_on"],
      [/^  (go_)?resource/,                "resource"],
      [/^  def install/,                   "install method"],
      [/^  def caveats/,                   "caveats method"],
      [/^  test do/,                       "test block"],
    ]

    present = component_list.map do |regex, name|
      lineno = text.line_number regex
      next unless lineno
      [lineno, name]
    end.compact
    present.each_cons(2) do |c1, c2|
      unless c1[0] < c2[0]
        problem "`#{c1[1]}` (line #{c1[0]}) should be put before `#{c2[1]}` (line #{c2[0]})"
      end
    end
    present.map!(&:last)
    if present.include?("stable block")
      %w[url checksum mirror].each do |component|
        if present.include?(component)
          problem "`#{component}` should be put inside `stable block`"
        end
      end
    end
    if present.include?("head") && present.include?("head block")
      problem "Should not have both `head` and `head do`"
    end
    if present.include?("bottle modifier") && present.include?("bottle block")
      problem "Should not have `bottle :unneeded/:disable` and `bottle do`"
    end
  end

  def audit_class
    if @strict
      unless formula.test_defined?
        problem "A `test do` test block should be added"
      end
    end

    classes = %w[GithubGistFormula ScriptFileFormula AmazonWebServicesFormula]
    klass = classes.find do |c|
      Object.const_defined?(c) && formula.class < Object.const_get(c)
    end

    problem "#{klass} is deprecated, use Formula instead" if klass
  end

  # core aliases + tap alias names + tap alias full name
  @@aliases ||= Formula.aliases + Formula.tap_aliases

  def audit_formula_name
    return unless @strict
    # skip for non-official taps
    return if formula.tap.nil? || !formula.tap.official?

    name = formula.name
    full_name = formula.full_name

    if Formula.aliases.include? name
      problem "Formula name conflicts with existing aliases."
      return
    end

    if oldname = CoreFormulaRepository.instance.formula_renames[name]
      problem "'#{name}' is reserved as the old name of #{oldname}"
      return
    end

    if !formula.core_formula? && Formula.core_names.include?(name)
      problem "Formula name conflicts with existing core formula."
      return
    end

    @@local_official_taps_name_map ||= Tap.select(&:official?).flat_map(&:formula_names).
      reduce(Hash.new) do |name_map, tap_formula_full_name|
        tap_formula_name = tap_formula_full_name.split("/").last
        name_map[tap_formula_name] ||= []
        name_map[tap_formula_name] << tap_formula_full_name
        name_map
      end

    same_name_tap_formulae = @@local_official_taps_name_map[name] || []

    if @online
      @@remote_official_taps ||= OFFICIAL_TAPS - Tap.select(&:official?).map(&:repo)

      same_name_tap_formulae += @@remote_official_taps.map do |tap|
        Thread.new { Homebrew.search_tap "homebrew", tap, name }
      end.flat_map(&:value)
    end

    same_name_tap_formulae.delete(full_name)

    if same_name_tap_formulae.size > 0
      problem "Formula name conflicts with #{same_name_tap_formulae.join ", "}"
    end
  end

  def audit_deps
    @specs.each do |spec|
      # Check for things we don't like to depend on.
      # We allow non-Homebrew installs whenever possible.
      spec.deps.each do |dep|
        begin
          dep_f = dep.to_formula
        rescue TapFormulaUnavailableError
          # Don't complain about missing cross-tap dependencies
          next
        rescue FormulaUnavailableError
          problem "Can't find dependency #{dep.name.inspect}."
          next
        rescue TapFormulaAmbiguityError
          problem "Ambiguous dependency #{dep.name.inspect}."
          next
        rescue TapFormulaWithOldnameAmbiguityError
          problem "Ambiguous oldname dependency #{dep.name.inspect}."
          next
        end

        if dep_f.oldname && dep.name.split("/").last == dep_f.oldname
          problem "Dependency '#{dep.name}' was renamed; use new name '#{dep_f.name}'."
        end

        if @@aliases.include?(dep.name)
          problem "Dependency '#{dep.name}' is an alias; use the canonical name '#{dep.to_formula.full_name}'."
        end

        dep.options.reject do |opt|
          next true if dep_f.option_defined?(opt)
          dep_f.requirements.detect do |r|
            if r.recommended?
              opt.name == "with-#{r.name}"
            elsif r.optional?
              opt.name == "without-#{r.name}"
            end
          end
        end.each do |opt|
          problem "Dependency #{dep} does not define option #{opt.name.inspect}"
        end

        case dep.name
        when *BUILD_TIME_DEPS
          next if dep.build? || dep.run?
          problem <<-EOS.undent
            #{dep} dependency should be
              depends_on "#{dep}" => :build
            Or if it is indeed a runtime dependency
              depends_on "#{dep}" => :run
          EOS
        when "git"
          problem "Don't use git as a dependency"
        when "mercurial"
          problem "Use `depends_on :hg` instead of `depends_on 'mercurial'`"
        when "ruby"
          problem "Don't use ruby as a dependency. We allow non-Homebrew ruby installations."
        when "gfortran"
          problem "Use `depends_on :fortran` instead of `depends_on 'gfortran'`"
        when "open-mpi", "mpich"
          problem <<-EOS.undent
            There are multiple conflicting ways to install MPI. Use an MPIRequirement:
              depends_on :mpi => [<lang list>]
            Where <lang list> is a comma delimited list that can include:
              :cc, :cxx, :f77, :f90
            EOS
        end
      end
    end
  end

  def audit_conflicts
    formula.conflicts.each do |c|
      begin
        Formulary.factory(c.name)
      rescue TapFormulaUnavailableError
        # Don't complain about missing cross-tap conflicts.
        next
      rescue FormulaUnavailableError
        problem "Can't find conflicting formula #{c.name.inspect}."
      rescue TapFormulaAmbiguityError, TapFormulaWithOldnameAmbiguityError
        problem "Ambiguous conflicting formula #{c.name.inspect}."
      end
    end
  end

  def audit_options
    formula.options.each do |o|
      next unless @strict
      if o.name !~ /with(out)?-/ && o.name != "c++11" && o.name != "universal" && o.name != "32-bit"
        problem "Options should begin with with/without. Migrate '--#{o.name}' with `deprecated_option`."
      end

      if o.name =~ /^with(out)?-(?:checks?|tests)$/
        problem "Use '--with#{$1}-test' instead of '--#{o.name}'. Migrate '--#{o.name}' with `deprecated_option`."
      end
    end
  end

  def audit_desc
    # For now, only check the description when using `--strict`
    return unless @strict

    desc = formula.desc

    unless desc && desc.length > 0
      problem "Formula should have a desc (Description)."
      return
    end

    # Make sure the formula name plus description is no longer than 80 characters
    linelength = formula.full_name.length + ": ".length + desc.length
    if linelength > 80
      problem <<-EOS.undent
        Description is too long. \"name: desc\" should be less than 80 characters.
        Length is calculated as #{formula.full_name} + desc. (currently #{linelength})
      EOS
    end

    if desc =~ /([Cc]ommand ?line)/
      problem "Description should use \"command-line\" instead of \"#{$1}\""
    end

    if desc =~ /^([Aa]n?)\s/
      problem "Description shouldn't start with an indefinite article (#{$1})"
    end

    if desc.downcase.start_with? "#{formula.name} "
      problem "Description shouldn't include the formula name"
    end
  end

  def audit_homepage
    homepage = formula.homepage

    unless homepage =~ %r{^https?://}
      problem "The homepage should start with http or https (URL is #{homepage})."
    end

    # Check for http:// GitHub homepage urls, https:// is preferred.
    # Note: only check homepages that are repo pages, not *.github.com hosts
    if homepage =~ %r{^http://github\.com/}
      problem "Please use https:// for #{homepage}"
    end

    # Savannah has full SSL/TLS support but no auto-redirect.
    # Doesn't apply to the download URLs, only the homepage.
    if homepage =~ %r{^http://savannah\.nongnu\.org/}
      problem "Please use https:// for #{homepage}"
    end

    # Freedesktop is complicated to handle - It has SSL/TLS, but only on certain subdomains.
    # To enable https Freedesktop change the URL from http://project.freedesktop.org/wiki to
    # https://wiki.freedesktop.org/project_name.
    # "Software" is redirected to https://wiki.freedesktop.org/www/Software/project_name
    if homepage =~ %r{^http://((?:www|nice|libopenraw|liboil|telepathy|xorg)\.)?freedesktop\.org/(?:wiki/)?}
      if homepage =~ /Software/
        problem "#{homepage} should be styled `https://wiki.freedesktop.org/www/Software/project_name`"
      else
        problem "#{homepage} should be styled `https://wiki.freedesktop.org/project_name`"
      end
    end

    # Google Code homepages should end in a slash
    if homepage =~ %r{^https?://code\.google\.com/p/[^/]+[^/]$}
      problem "#{homepage} should end with a slash"
    end

    # People will run into mixed content sometimes, but we should enforce and then add
    # exemptions as they are discovered. Treat mixed content on homepages as a bug.
    # Justify each exemptions with a code comment so we can keep track here.
    if homepage =~ %r{^http://[^/]*github\.io/}
      problem "Please use https:// for #{homepage}"
    end

    # There's an auto-redirect here, but this mistake is incredibly common too.
    # Only applies to the homepage and subdomains for now, not the FTP URLs.
    if homepage =~ %r{^http://((?:build|cloud|developer|download|extensions|git|glade|help|library|live|nagios|news|people|projects|rt|static|wiki|www)\.)?gnome\.org}
      problem "Please use https:// for #{homepage}"
    end

    # Compact the above into this list as we're able to remove detailed notations, etc over time.
    case homepage
    when %r{^http://[^/]*\.apache\.org},
         %r{^http://packages\.debian\.org},
         %r{^http://wiki\.freedesktop\.org/},
         %r{^http://((?:www)\.)?gnupg.org/},
         %r{^http://ietf\.org},
         %r{^http://[^/.]+\.ietf\.org},
         %r{^http://[^/.]+\.tools\.ietf\.org},
         %r{^http://www\.gnu\.org/},
         %r{^http://code\.google\.com/},
         %r{^http://bitbucket\.org/},
         %r{^http://(?:[^/]*\.)?archive\.org}
      problem "Please use https:// for #{homepage}"
    end

    return unless @online
    begin
      nostdout { curl "--connect-timeout", "15", "-o", "/dev/null", homepage }
    rescue ErrorDuringExecution
      problem "The homepage is not reachable (curl exit code #{$?.exitstatus})"
    end
  end

  def audit_bottle_spec
    if formula.bottle_disabled? && !formula.bottle_disable_reason.valid?
      problem "Unrecognized bottle modifier"
    end
  end

  def audit_github_repository
    return unless @online

    regex = %r{https?://github.com/([^/]+)/([^/]+)/?.*}
    _, user, repo = *regex.match(formula.stable.url) if formula.stable
    _, user, repo = *regex.match(formula.homepage) unless user
    return if !user || !repo

    repo.gsub!(/.git$/, "")

    begin
      metadata = GitHub.repository(user, repo)
    rescue GitHub::HTTPNotFoundError
      return
    end

    problem "GitHub fork (not canonical repository)" if metadata["fork"]
    if (metadata["forks_count"] < 10) && (metadata["subscribers_count"] < 10) &&
       (metadata["stargazers_count"] < 20)
      problem "GitHub repository not notable enough (<10 forks, <10 watchers and <20 stars)"
    end

    if Date.parse(metadata["created_at"]) > (Date.today - 30)
      problem "GitHub repository too new (<30 days old)"
    end
  end

  def audit_specs
    if head_only?(formula) && formula.tap.to_s.downcase !~ /-head-only$/
      problem "Head-only (no stable download)"
    end

    if devel_only?(formula) && formula.tap.to_s.downcase !~ /-devel-only$/
      problem "Devel-only (no stable download)"
    end

    %w[Stable Devel HEAD].each do |name|
      next unless spec = formula.send(name.downcase)

      ra = ResourceAuditor.new(spec).audit
      problems.concat ra.problems.map { |problem| "#{name}: #{problem}" }

      spec.resources.each_value do |resource|
        ra = ResourceAuditor.new(resource).audit
        problems.concat ra.problems.map { |problem|
          "#{name} resource #{resource.name.inspect}: #{problem}"
        }
      end

      spec.patches.each { |p| audit_patch(p) if p.external? }
    end

    %w[Stable Devel].each do |name|
      next unless spec = formula.send(name.downcase)
      version = spec.version
      if version.to_s !~ /\d/
        problem "#{name}: version (#{version}) is set to a string without a digit"
      end
    end

    if formula.stable && formula.devel
      if formula.devel.version < formula.stable.version
        problem "devel version #{formula.devel.version} is older than stable version #{formula.stable.version}"
      elsif formula.devel.version == formula.stable.version
        problem "stable and devel versions are identical"
      end
    end

    stable = formula.stable
    case stable && stable.url
    when %r{download\.gnome\.org/sources}, %r{ftp\.gnome\.org/pub/GNOME/sources}i
      version = Version.parse(stable.url)
      if version >= Version.new("1.0")
        minor_version = version.to_s.split(".", 3)[1].to_i
        if minor_version.odd?
          problem "#{stable.version} is a development release"
        end
      end
    end
  end

  def audit_revision
    return unless formula.tap # skip formula not from core or any taps
    return unless formula.tap.git? # git log is required

    fv = FormulaVersions.new(formula, :max_depth => 10)
    revision_map = fv.revision_map("origin/master")
    if (revisions = revision_map[formula.version]).any?
      problem "revision should not decrease" if formula.revision < revisions.max
    elsif formula.revision != 0
      if formula.stable
        if revision_map[formula.stable.version].empty? # check stable spec
          problem "revision should be removed"
        end
      else # head/devel-only formula
        problem "revision should be removed"
      end
    end
  end

  def audit_legacy_patches
    return unless formula.respond_to?(:patches)
    legacy_patches = Patch.normalize_legacy_patches(formula.patches).grep(LegacyPatch)
    if legacy_patches.any?
      problem "Use the patch DSL instead of defining a 'patches' method"
      legacy_patches.each { |p| audit_patch(p) }
    end
  end

  def audit_patch(patch)
    case patch.url
    when /raw\.github\.com/, %r{gist\.github\.com/raw}, %r{gist\.github\.com/.+/raw},
      %r{gist\.githubusercontent\.com/.+/raw}
      unless patch.url =~ /[a-fA-F0-9]{40}/
        problem "GitHub/Gist patches should specify a revision:\n#{patch.url}"
      end
    when %r{macports/trunk}
      problem "MacPorts patches should specify a revision instead of trunk:\n#{patch.url}"
    when %r{^http://trac\.macports\.org}
      problem "Patches from MacPorts Trac should be https://, not http:\n#{patch.url}"
    when %r{^http://bugs\.debian\.org}
      problem "Patches from Debian should be https://, not http:\n#{patch.url}"
    end
  end

  def audit_text
    if text =~ /system\s+['"]scons/
      problem "use \"scons *args\" instead of \"system 'scons', *args\""
    end

    if text =~ /system\s+['"]xcodebuild/
      problem %(use "xcodebuild *args" instead of "system 'xcodebuild', *args")
    end

    if text =~ /xcodebuild[ (]["'*]/ && text !~ /SYMROOT=/
      problem %(xcodebuild should be passed an explicit "SYMROOT")
    end

    if text =~ /Formula\.factory\(/
      problem "\"Formula.factory(name)\" is deprecated in favor of \"Formula[name]\""
    end

    if text =~ /system "npm", "install"/ && text !~ %r[opt_libexec\}/npm/bin] && formula.name !~ /^kibana(\d{2})?$/
      need_npm = "\#{Formula[\"node\"].opt_libexec\}/npm/bin"
      problem <<-EOS.undent
       Please add ENV.prepend_path \"PATH\", \"#{need_npm}"\ to def install
      EOS
    end
  end

  def audit_line(line, lineno)
    if line =~ /<(Formula|AmazonWebServicesFormula|ScriptFileFormula|GithubGistFormula)/
      problem "Use a space in class inheritance: class Foo < #{$1}"
    end

    # Commented-out cmake support from default template
    if line =~ /# system "cmake/
      problem "Commented cmake call found"
    end

    # Comments from default template
    [
      "# PLEASE REMOVE",
      "# Documentation:",
      "# if this fails, try separate make/make install steps",
      "# The URL of the archive",
      "## Naming --",
      "# if your formula requires any X11/XQuartz components",
      "# if your formula fails when building in parallel",
      "# Remove unrecognized options if warned by configure",
    ].each do |comment|
      if line.include? comment
        problem "Please remove default template comments"
      end
    end

    # FileUtils is included in Formula
    # encfs modifies a file with this name, so check for some leading characters
    if line =~ /[^'"\/]FileUtils\.(\w+)/
      problem "Don't need 'FileUtils.' before #{$1}."
    end

    # Check for long inreplace block vars
    if line =~ /inreplace .* do \|(.{2,})\|/
      problem "\"inreplace <filenames> do |s|\" is preferred over \"|#{$1}|\"."
    end

    # Check for string interpolation of single values.
    if line =~ /(system|inreplace|gsub!|change_make_var!).*[ ,]"#\{([\w.]+)\}"/
      problem "Don't need to interpolate \"#{$2}\" with #{$1}"
    end

    # Check for string concatenation; prefer interpolation
    if line =~ /(#\{\w+\s*\+\s*['"][^}]+\})/
      problem "Try not to concatenate paths in string interpolation:\n   #{$1}"
    end

    # Prefer formula path shortcuts in Pathname+
    if line =~ %r{\(\s*(prefix\s*\+\s*(['"])(bin|include|libexec|lib|sbin|share|Frameworks)[/'"])}
      problem "\"(#{$1}...#{$2})\" should be \"(#{$3.downcase}+...)\""
    end

    if line =~ /((man)\s*\+\s*(['"])(man[1-8])(['"]))/
      problem "\"#{$1}\" should be \"#{$4}\""
    end

    # Prefer formula path shortcuts in strings
    if line =~ %r[(\#\{prefix\}/(bin|include|libexec|lib|sbin|share|Frameworks))]
      problem "\"#{$1}\" should be \"\#{#{$2.downcase}}\""
    end

    if line =~ %r[((\#\{prefix\}/share/man/|\#\{man\}/)(man[1-8]))]
      problem "\"#{$1}\" should be \"\#{#{$3}}\""
    end

    if line =~ %r[((\#\{share\}/(man)))[/'"]]
      problem "\"#{$1}\" should be \"\#{#{$3}}\""
    end

    if line =~ %r[(\#\{prefix\}/share/(info|man))]
      problem "\"#{$1}\" should be \"\#{#{$2}}\""
    end

    if line =~ /depends_on :(automake|autoconf|libtool)/
      problem ":#{$1} is deprecated. Usage should be \"#{$1}\""
    end

    # Commented-out depends_on
    if line =~ /#\s*depends_on\s+(.+)\s*$/
      problem "Commented-out dep #{$1}"
    end

    # No trailing whitespace, please
    if line =~ /[\t ]+$/
      problem "#{lineno}: Trailing whitespace was found"
    end

    if line =~ /if\s+ARGV\.include\?\s+'--(HEAD|devel)'/
      problem "Use \"if build.#{$1.downcase}?\" instead"
    end

    if line =~ /make && make/
      problem "Use separate make calls"
    end

    if line =~ /^[ ]*\t/
      problem "Use spaces instead of tabs for indentation"
    end

    if line =~ /ENV\.x11/
      problem "Use \"depends_on :x11\" instead of \"ENV.x11\""
    end

    # Avoid hard-coding compilers
    if line =~ %r{(system|ENV\[.+\]\s?=)\s?['"](/usr/bin/)?(gcc|llvm-gcc|clang)['" ]}
      problem "Use \"\#{ENV.cc}\" instead of hard-coding \"#{$3}\""
    end

    if line =~ %r{(system|ENV\[.+\]\s?=)\s?['"](/usr/bin/)?((g|llvm-g|clang)\+\+)['" ]}
      problem "Use \"\#{ENV.cxx}\" instead of hard-coding \"#{$3}\""
    end

    if line =~ /system\s+['"](env|export)(\s+|['"])/
      problem "Use ENV instead of invoking '#{$1}' to modify the environment"
    end

    if line =~ /version == ['"]HEAD['"]/
      problem "Use 'build.head?' instead of inspecting 'version'"
    end

    if line =~ /build\.include\?[\s\(]+['"]\-\-(.*)['"]/
      problem "Reference '#{$1}' without dashes"
    end

    if line =~ /build\.include\?[\s\(]+['"]with(out)?-(.*)['"]/
      problem "Use build.with#{$1}? \"#{$2}\" instead of build.include? 'with#{$1}-#{$2}'"
    end

    if line =~ /build\.with\?[\s\(]+['"]-?-?with-(.*)['"]/
      problem "Don't duplicate 'with': Use `build.with? \"#{$1}\"` to check for \"--with-#{$1}\""
    end

    if line =~ /build\.without\?[\s\(]+['"]-?-?without-(.*)['"]/
      problem "Don't duplicate 'without': Use `build.without? \"#{$1}\"` to check for \"--without-#{$1}\""
    end

    if line =~ /unless build\.with\?(.*)/
      problem "Use if build.without?#{$1} instead of unless build.with?#{$1}"
    end

    if line =~ /unless build\.without\?(.*)/
      problem "Use if build.with?#{$1} instead of unless build.without?#{$1}"
    end

    if line =~ /(not\s|!)\s*build\.with?\?/
      problem "Don't negate 'build.without?': use 'build.with?'"
    end

    if line =~ /(not\s|!)\s*build\.without?\?/
      problem "Don't negate 'build.with?': use 'build.without?'"
    end

    if line =~ /ARGV\.(?!(debug\?|verbose\?|value[\(\s]))/
      problem "Use build instead of ARGV to check options"
    end

    if line =~ /def options/
      problem "Use new-style option definitions"
    end

    if line =~ /def test$/
      problem "Use new-style test definitions (test do)"
    end

    if line =~ /MACOS_VERSION/
      problem "Use MacOS.version instead of MACOS_VERSION"
    end

    # TODO: comment out this after core code and formulae separation.
    # if line =~ /MACOS_FULL_VERSION/
    #   problem "Use MacOS.full_version instead of MACOS_FULL_VERSION"
    # end

    cats = %w[leopard snow_leopard lion mountain_lion].join("|")
    if line =~ /MacOS\.(?:#{cats})\?/
      problem "\"#{$&}\" is deprecated, use a comparison to MacOS.version instead"
    end

    if line =~ /skip_clean\s+:all/
      problem "`skip_clean :all` is deprecated; brew no longer strips symbols\n" \
              "\tPass explicit paths to prevent Homebrew from removing empty folders."
    end

    if line =~ /depends_on [A-Z][\w:]+\.new$/
      problem "`depends_on` can take requirement classes instead of instances"
    end

    if line =~ /^def (\w+).*$/
      problem "Define method #{$1.inspect} in the class body, not at the top-level"
    end

    if line =~ /ENV.fortran/ && !formula.requirements.map(&:class).include?(FortranRequirement)
      problem "Use `depends_on :fortran` instead of `ENV.fortran`"
    end

    if line =~ /JAVA_HOME/i && !formula.requirements.map(&:class).include?(JavaRequirement)
      problem "Use `depends_on :java` to set JAVA_HOME"
    end

    if line =~ /depends_on :(.+) (if.+|unless.+)$/
      audit_conditional_dep($1.to_sym, $2, $&)
    end

    if line =~ /depends_on ['"](.+)['"] (if.+|unless.+)$/
      audit_conditional_dep($1, $2, $&)
    end

    if line =~ /(Dir\[("[^\*{},]+")\])/
      problem "#{$1} is unnecessary; just use #{$2}"
    end

    if line =~ /system (["'](#{FILEUTILS_METHODS})["' ])/o
      system = $1
      method = $2
      problem "Use the `#{method}` Ruby method instead of `system #{system}`"
    end

    if line =~ /assert [^!]+\.include?/
      problem "Use `assert_match` instead of `assert ...include?`"
    end

    if @strict
      if line =~ /system (["'][^"' ]*(?:\s[^"' ]*)+["'])/
        bad_system = $1
        unless %w[| < > & ; *].any? { |c| bad_system.include? c }
          good_system = bad_system.gsub(" ", "\", \"")
          problem "Use `system #{good_system}` instead of `system #{bad_system}` "
        end
      end

      if line =~ /(require ["']formula["'])/
        problem "`#{$1}` is now unnecessary"
      end

      if line =~ %r{#\{share\}/#{formula.name}[/'"]}
        problem "Use \#{pkgshare} instead of \#{share}/#{formula.name}"
      end

      if line =~ %r{share/"#{formula.name}[/'"]}
        problem "Use pkgshare instead of (share/\"#{formula.name}\")"
      end
    end
  end

  def audit_caveats
    caveats = formula.caveats

    if caveats =~ /setuid/
      problem "Don't recommend setuid in the caveats, suggest sudo instead."
    end
  end

  def audit_reverse_migration
    # Only enforce for new formula being re-added to core
    return unless @strict
    return unless formula.core_formula?

    if TAP_MIGRATIONS.key?(formula.name)
      problem <<-EOS.undent
       #{formula.name} seems to be listed in tap_migrations.rb!
       Please remove #{formula.name} from present tap & tap_migrations.rb
       before submitting it to Homebrew/homebrew.
      EOS
    end
  end

  def audit_prefix_has_contents
    return unless formula.prefix.directory?

    if Keg.new(formula.prefix).empty_installation?
      problem <<-EOS.undent
        The installation seems to be empty. Please ensure the prefix
        is set correctly and expected files are installed.
        The prefix configure/make argument may be case-sensitive.
      EOS
    end
  end

  def audit_conditional_dep(dep, condition, line)
    quoted_dep = quote_dep(dep)
    dep = Regexp.escape(dep.to_s)

    case condition
    when /if build\.include\? ['"]with-#{dep}['"]$/, /if build\.with\? ['"]#{dep}['"]$/
      problem %(Replace #{line.inspect} with "depends_on #{quoted_dep} => :optional")
    when /unless build\.include\? ['"]without-#{dep}['"]$/, /unless build\.without\? ['"]#{dep}['"]$/
      problem %(Replace #{line.inspect} with "depends_on #{quoted_dep} => :recommended")
    end
  end

  def quote_dep(dep)
    Symbol === dep ? dep.inspect : "'#{dep}'"
  end

  def audit_check_output(output)
    problem(output) if output
  end

  def audit
    audit_file
    audit_formula_name
    audit_class
    audit_specs
    audit_revision
    audit_desc
    audit_homepage
    audit_bottle_spec
    audit_github_repository
    audit_deps
    audit_conflicts
    audit_options
    audit_legacy_patches
    audit_text
    audit_caveats
    text.without_patch.split("\n").each_with_index { |line, lineno| audit_line(line, lineno+1) }
    audit_installed
    audit_prefix_has_contents
    audit_reverse_migration
  end

  private

  def problem(p)
    @problems << p
  end

  def head_only?(formula)
    formula.head && formula.devel.nil? && formula.stable.nil?
  end

  def devel_only?(formula)
    formula.devel && formula.stable.nil?
  end
end

class ResourceAuditor
  attr_reader :problems
  attr_reader :version, :checksum, :using, :specs, :url, :mirrors, :name

  def initialize(resource)
    @name     = resource.name
    @version  = resource.version
    @checksum = resource.checksum
    @url      = resource.url
    @mirrors  = resource.mirrors
    @using    = resource.using
    @specs    = resource.specs
    @problems = []
  end

  def audit
    audit_version
    audit_checksum
    audit_download_strategy
    audit_urls
    self
  end

  def audit_version
    if version.nil?
      problem "missing version"
    elsif version.to_s.empty?
      problem "version is set to an empty string"
    elsif !version.detected_from_url?
      version_text = version
      version_url = Version.detect(url, specs)
      if version_url.to_s == version_text.to_s && version.instance_of?(Version)
        problem "version #{version_text} is redundant with version scanned from URL"
      end
    end

    if version.to_s =~ /^v/
      problem "version #{version} should not have a leading 'v'"
    end

    if version.to_s =~ /_\d+$/
      problem "version #{version} should not end with an underline and a number"
    end
  end

  def audit_checksum
    return unless checksum

    case checksum.hash_type
    when :md5
      problem "MD5 checksums are deprecated, please use SHA256"
      return
    when :sha1
      problem "SHA1 checksums are deprecated, please use SHA256"
      return
    when :sha256 then len = 64
    end

    if checksum.empty?
      problem "#{checksum.hash_type} is empty"
    else
      problem "#{checksum.hash_type} should be #{len} characters" unless checksum.hexdigest.length == len
      problem "#{checksum.hash_type} contains invalid characters" unless checksum.hexdigest =~ /^[a-fA-F0-9]+$/
      problem "#{checksum.hash_type} should be lowercase" unless checksum.hexdigest == checksum.hexdigest.downcase
    end
  end

  def audit_download_strategy
    if url =~ %r{^(cvs|bzr|hg|fossil)://} || url =~ %r{^(svn)\+http://}
      problem "Use of the #{$&} scheme is deprecated, pass `:using => :#{$1}` instead"
    end

    url_strategy = DownloadStrategyDetector.detect(url)

    if using == :git || url_strategy == GitDownloadStrategy
      if specs[:tag] && !specs[:revision]
        problem "Git should specify :revision when a :tag is specified."
      end
    end

    return unless using

    if using == :ssl3 || \
       (Object.const_defined?("CurlSSL3DownloadStrategy") && using == CurlSSL3DownloadStrategy)
      problem "The SSL3 download strategy is deprecated, please choose a different URL"
    elsif (Object.const_defined?("CurlUnsafeDownloadStrategy") && using == CurlUnsafeDownloadStrategy) || \
          (Object.const_defined?("UnsafeSubversionDownloadStrategy") && using == UnsafeSubversionDownloadStrategy)
      problem "#{using.name} is deprecated, please choose a different URL"
    end

    if using == :cvs
      mod = specs[:module]

      if mod == name
        problem "Redundant :module value in URL"
      end

      if url =~ %r{:[^/]+$}
        mod = url.split(":").last

        if mod == name
          problem "Redundant CVS module appended to URL"
        else
          problem "Specify CVS module as `:module => \"#{mod}\"` instead of appending it to the URL"
        end
      end
    end

    using_strategy = DownloadStrategyDetector.detect("", using)

    if url_strategy == using_strategy
      problem "Redundant :using value in URL"
    end
  end

  def audit_urls
    # Check GNU urls; doesn't apply to mirrors
    if url =~ %r{^(?:https?|ftp)://(?!alpha).+/gnu/}
      problem "Please use \"http://ftpmirror.gnu.org\" instead of #{url}."
    end

    # GNU's ftpmirror does NOT support SSL/TLS.
    if url =~ %r{^https://ftpmirror\.gnu\.org/}
      problem "Please use http:// for #{url}"
    end

    if mirrors.include?(url)
      problem "URL should not be duplicated as a mirror: #{url}"
    end

    urls = [url] + mirrors

    # Check a variety of SSL/TLS URLs that don't consistently auto-redirect
    # or are overly common errors that need to be reduced & fixed over time.
    urls.each do |p|
      case p
      when %r{^http://ftp\.gnu\.org/},
           %r{^http://[^/]*\.apache\.org/},
           %r{^http://code\.google\.com/},
           %r{^http://fossies\.org/},
           %r{^http://mirrors\.kernel\.org/},
           %r{^http://(?:[^/]*\.)?bintray\.com/},
           %r{^http://tools\.ietf\.org/},
           %r{^http://www\.mirrorservice\.org/},
           %r{^http://launchpad\.net/},
           %r{^http://bitbucket\.org/},
           %r{^http://hackage\.haskell\.org/},
           %r{^http://(?:[^/]*\.)?archive\.org}
        problem "Please use https:// for #{p}"
      when %r{^http://search\.mcpan\.org/CPAN/(.*)}i
        problem "#{p} should be `https://cpan.metacpan.org/#{$1}`"
      when %r{^(http|ftp)://ftp\.gnome\.org/pub/gnome/(.*)}i
        problem "#{p} should be `https://download.gnome.org/#{$2}`"
      end
    end

    # Check SourceForge urls
    urls.each do |p|
      # Skip if the URL looks like a SVN repo
      next if p =~ %r{/svnroot/}
      next if p =~ /svn\.sourceforge/

      # Is it a sourceforge http(s) URL?
      next unless p =~ %r{^https?://.*\b(sourceforge|sf)\.(com|net)}

      if p =~ /(\?|&)use_mirror=/
        problem "Don't use #{$1}use_mirror in SourceForge urls (url is #{p})."
      end

      if p =~ /\/download$/
        problem "Don't use /download in SourceForge urls (url is #{p})."
      end

      if p =~ %r{^https?://sourceforge\.}
        problem "Use https://downloads.sourceforge.net to get geolocation (url is #{p})."
      end

      if p =~ %r{^https?://prdownloads\.}
        problem "Don't use prdownloads in SourceForge urls (url is #{p}).\n" \
                "\tSee: http://librelist.com/browser/homebrew/2011/1/12/prdownloads-is-bad/"
      end

      if p =~ %r{^http://\w+\.dl\.}
        problem "Don't use specific dl mirrors in SourceForge urls (url is #{p})."
      end

      if p.start_with? "http://downloads"
        problem "Please use https:// for #{p}"
      end
    end

    # Check for Google Code download urls, https:// is preferred
    # Intentionally not extending this to SVN repositories due to certificate
    # issues.
    urls.grep(%r{^http://.*\.googlecode\.com/files.*}) do |u|
      problem "Please use https:// for #{u}"
    end

    # Check for new-url Google Code download urls, https:// is preferred
    urls.grep(%r{^http://code\.google\.com/}) do |u|
      problem "Please use https:// for #{u}"
    end

    # Check for git:// GitHub repo urls, https:// is preferred.
    urls.grep(%r{^git://[^/]*github\.com/}) do |u|
      problem "Please use https:// for #{u}"
    end

    # Check for git:// Gitorious repo urls, https:// is preferred.
    urls.grep(%r{^git://[^/]*gitorious\.org/}) do |u|
      problem "Please use https:// for #{u}"
    end

    # Check for http:// GitHub repo urls, https:// is preferred.
    urls.grep(%r{^http://github\.com/.*\.git$}) do |u|
      problem "Please use https:// for #{u}"
    end

    # Use new-style archive downloads
    urls.each do |u|
      next unless u =~ %r{https://.*github.*/(?:tar|zip)ball/} && u !~ /\.git$/
      problem "Use /archive/ URLs for GitHub tarballs (url is #{u})."
    end

    # Don't use GitHub .zip files
    urls.each do |u|
      next unless u =~ %r{https://.*github.*/(archive|releases)/.*\.zip$} && u !~ %r{releases/download}
      problem "Use GitHub tarballs rather than zipballs (url is #{u})."
    end
  end

  def problem(text)
    @problems << text
  end
end
