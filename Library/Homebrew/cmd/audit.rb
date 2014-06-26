require 'formula'
require 'utils'
require 'extend/ENV'
require 'formula_cellar_checks'

module Homebrew
  def audit
    formula_count = 0
    problem_count = 0

    ENV.activate_extensions!
    ENV.setup_build_environment

    ff = if ARGV.named.empty?
      Formula
    else
      ARGV.formulae
    end

    ff.each do |f|
      fa = FormulaAuditor.new f
      fa.audit

      unless fa.problems.empty?
        puts "#{f.name}:"
        fa.problems.each { |p| puts " * #{p}" }
        puts
        formula_count += 1
        problem_count += fa.problems.size
      end
    end

    unless problem_count.zero?
      ofail "#{problem_count} problems in #{formula_count} formulae"
    end
  end
end

class Module
  def redefine_const(name, value)
    __send__(:remove_const, name) if const_defined?(name)
    const_set(name, value)
  end
end

# Formula extensions for auditing
class Formula
  def head_only?
    @head and @stable.nil?
  end

  def text
    @text ||= FormulaText.new(@path)
  end
end

class FormulaText
  def initialize path
    @text = path.open("rb", &:read)
  end

  def without_patch
    @text.split("__END__")[0].strip()
  end

  def has_DATA?
    /\bDATA\b/ =~ @text
  end

  def has_END?
    /^__END__$/ =~ @text
  end

  def has_trailing_newline?
    /\Z\n/ =~ @text
  end
end

class FormulaAuditor
  include FormulaCellarChecks

  attr_reader :f, :text, :problems

  BUILD_TIME_DEPS = %W[
    autoconf
    automake
    boost-build
    bsdmake
    cmake
    imake
    intltool
    libtool
    pkg-config
    scons
    smake
    swig
  ]

  def initialize f
    @f = f
    @problems = []
    @text = f.text.without_patch
    @specs = %w{stable devel head}.map { |s| f.send(s) }.compact

    # We need to do this in case the formula defines a patch that uses DATA.
    f.class.redefine_const :DATA, ""
  end

  def audit_file
    unless f.path.stat.mode.to_s(8) == "100644"
      problem "Incorrect file permissions: chmod 644 #{f.path}"
    end

    if f.text.has_DATA? and not f.text.has_END?
      problem "'DATA' was found, but no '__END__'"
    end

    if f.text.has_END? and not f.text.has_DATA?
      problem "'__END__' was found, but 'DATA' is not used"
    end

    unless f.text.has_trailing_newline?
      problem "File should end with a newline"
    end
  end

  def audit_deps
    # Don't depend_on aliases; use full name
    @@aliases ||= Formula.aliases
    f.deps.select { |d| @@aliases.include? d.name }.each do |d|
      real_name = d.to_formula.name
      problem "Dependency '#{d}' is an alias; use the canonical name '#{real_name}'."
    end

    # Check for things we don't like to depend on.
    # We allow non-Homebrew installs whenever possible.
    f.deps.each do |dep|
      begin
        dep_f = dep.to_formula
      rescue TapFormulaUnavailableError
        # Don't complain about missing cross-tap dependencies
        next
      rescue FormulaUnavailableError
        problem "Can't find dependency #{dep.name.inspect}."
        next
      end

      dep.options.reject do |opt|
        next true if dep_f.build.has_option?(opt.name)
        dep_f.requirements.detect do |r|
          if r.tags.include? :recommended
            opt.name == "with-#{r.name}"
          elsif r.tags.include? :optional
            opt.name == "without-#{r.name}"
          end
        end
      end.each do |opt|
        problem "Dependency #{dep} does not define option #{opt.name.inspect}"
      end

      case dep.name
      when *BUILD_TIME_DEPS
        next if dep.build? or dep.run?
        problem %{#{dep} dependency should be "depends_on '#{dep}' => :build"}
      when "git", "ruby", "mercurial"
        problem <<-EOS.undent
          Don't use #{dep} as a dependency. We allow non-Homebrew
          #{dep} installations.
          EOS
      when 'gfortran'
        problem "Use `depends_on :fortran` instead of `depends_on 'gfortran'`"
      when 'open-mpi', 'mpich2'
        problem <<-EOS.undent
          There are multiple conflicting ways to install MPI. Use an MPIDependency:
            depends_on :mpi => [<lang list>]
          Where <lang list> is a comma delimited list that can include:
            :cc, :cxx, :f77, :f90
          EOS
      end
    end
  end

  def audit_conflicts
    f.conflicts.each do |c|
      begin
        Formulary.factory(c.name)
      rescue FormulaUnavailableError
        problem "Can't find conflicting formula #{c.name.inspect}."
      end
    end
  end

  def audit_urls
    unless f.homepage =~ %r[^https?://]
      problem "The homepage should start with http or https (url is #{f.homepage})."
    end

    # Check for http:// GitHub homepage urls, https:// is preferred.
    # Note: only check homepages that are repo pages, not *.github.com hosts
    if f.homepage =~ %r[^http://github\.com/]
      problem "Use https:// URLs for homepages on GitHub (url is #{f.homepage})."
    end

    # Google Code homepages should end in a slash
    if f.homepage =~ %r[^https?://code\.google\.com/p/[^/]+[^/]$]
      problem "Google Code homepage should end with a slash (url is #{f.homepage})."
    end

    urls = @specs.map(&:url)

    # Check GNU urls; doesn't apply to mirrors
    urls.grep(%r[^(?:https?|ftp)://(?!alpha).+/gnu/]) do |u|
      problem "\"ftpmirror.gnu.org\" is preferred for GNU software (url is #{u})."
    end

    # the rest of the checks apply to mirrors as well
    urls.concat(@specs.map(&:mirrors).flatten)

    # Check SourceForge urls
    urls.each do |p|
      # Skip if the URL looks like a SVN repo
      next if p =~ %r[/svnroot/]
      next if p =~ %r[svn\.sourceforge]

      # Is it a sourceforge http(s) URL?
      next unless p =~ %r[^https?://.*\b(sourceforge|sf)\.(com|net)]

      if p =~ /(\?|&)use_mirror=/
        problem "Don't use #{$1}use_mirror in SourceForge urls (url is #{p})."
      end

      if p =~ /\/download$/
        problem "Don't use /download in SourceForge urls (url is #{p})."
      end

      if p =~ %r[^https?://sourceforge\.]
        problem "Use http://downloads.sourceforge.net to get geolocation (url is #{p})."
      end

      if p =~ %r[^https?://prdownloads\.]
        problem "Don't use prdownloads in SourceForge urls (url is #{p}).\n" +
                "\tSee: http://librelist.com/browser/homebrew/2011/1/12/prdownloads-is-bad/"
      end

      if p =~ %r[^http://\w+\.dl\.]
        problem "Don't use specific dl mirrors in SourceForge urls (url is #{p})."
      end

      if p.start_with? "http://downloads"
        problem "Use https:// URLs for downloads from SourceForge (url is #{p})."
      end
    end

    # Check for Google Code download urls, https:// is preferred
    urls.grep(%r[^http://.*\.googlecode\.com/files.*]) do |u|
      problem "Use https:// URLs for downloads from Google Code (url is #{u})."
    end

    # Check for git:// GitHub repo urls, https:// is preferred.
    urls.grep(%r[^git://[^/]*github\.com/]) do |u|
      problem "Use https:// URLs for accessing GitHub repositories (url is #{u})."
    end

    # Check for http:// GitHub repo urls, https:// is preferred.
    urls.grep(%r[^http://github\.com/.*\.git$]) do |u|
      problem "Use https:// URLs for accessing GitHub repositories (url is #{u})."
    end

    # Use new-style archive downloads
    urls.select { |u| u =~ %r[https://.*github.*/(?:tar|zip)ball/] && u !~ %r[\.git$] }.each do |u|
      problem "Use /archive/ URLs for GitHub tarballs (url is #{u})."
    end

    # Don't use GitHub .zip files
    urls.select { |u| u =~ %r[https://.*github.*/(archive|releases)/.*\.zip$] && u !~ %r[releases/download] }.each do |u|
      problem "Use GitHub tarballs rather than zipballs (url is #{u})."
    end
  end

  def audit_specs
    problem "Head-only (no stable download)" if f.head_only?

    %w[Stable Devel HEAD].each do |name|
      next unless spec = f.send(name.downcase)

      ra = ResourceAuditor.new(spec).audit
      problems.concat ra.problems.map { |problem| "#{name}: #{problem}" }

      spec.resources.each_value do |resource|
        ra = ResourceAuditor.new(resource).audit
        problems.concat ra.problems.map { |problem|
          "#{name} resource #{resource.name.inspect}: #{problem}"
        }
      end

      spec.patches.select(&:external?).each { |p| audit_patch(p) }
    end
  end

  def audit_patches
    patches = Patch.normalize_legacy_patches(f.patches)
    patches.grep(LegacyPatch).each { |p| audit_patch(p) }
  end

  def audit_patch(patch)
    case patch.url
    when %r[raw\.github\.com], %r[gist\.github\.com/raw], %r[gist\.github\.com/.+/raw],
      %r[gist\.githubusercontent\.com/.+/raw]
      unless patch.url =~ /[a-fA-F0-9]{40}/
        problem "GitHub/Gist patches should specify a revision:\n#{patch.url}"
      end
    when %r[macports/trunk]
      problem "MacPorts patches should specify a revision instead of trunk:\n#{patch.url}"
    when %r[^https?://github\.com/.*commit.*\.patch$]
      problem "GitHub appends a git version to patches; use .diff instead."
    end
  end

  def audit_text
    if text =~ /system\s+['"]scons/
      problem "use \"scons *args\" instead of \"system 'scons', *args\""
    end

    if text =~ /system\s+['"]xcodebuild/
      problem %{use "xcodebuild *args" instead of "system 'xcodebuild', *args"}
    end

    if text =~ /xcodebuild[ (]["'*]/ && text !~ /SYMROOT=/
      problem %{xcodebuild should be passed an explicit "SYMROOT"}
    end

    if text =~ /Formula\.factory\(/
      problem "\"Formula.factory(name)\" is deprecated in favor of \"Formula[name]\""
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
    if line =~ /# PLEASE REMOVE/
      problem "Please remove default template comments"
    end
    if line =~ /# if this fails, try separate make\/make install steps/
      problem "Please remove default template comments"
    end
    if line =~ /# if your formula requires any X11\/XQuartz components/
      problem "Please remove default template comments"
    end
    if line =~ /# if your formula's build system can't parallelize/
      problem "Please remove default template comments"
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

    if line =~ %r[((man)\s*\+\s*(['"])(man[1-8])(['"]))]
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
      # Python formulae need ARGV for Requirements
      problem "Use build instead of ARGV to check options",
              :whitelist => %w{pygobject3 qscintilla2}
    end

    if line =~ /def options/
      problem "Use new-style option definitions"
    end

    if line =~ /MACOS_VERSION/
      problem "Use MacOS.version instead of MACOS_VERSION"
    end

    cats = %w{leopard snow_leopard lion mountain_lion}.join("|")
    if line =~ /MacOS\.(?:#{cats})\?/
      problem "\"#{$&}\" is deprecated, use a comparison to MacOS.version instead"
    end

    if line =~ /skip_clean\s+:all/
      problem "`skip_clean :all` is deprecated; brew no longer strips symbols\n" +
              "\tPass explicit paths to prevent Homebrew from removing empty folders."
    end

    if line =~ /depends_on [A-Z][\w:]+\.new$/
      problem "`depends_on` can take requirement classes instead of instances"
    end

    if line =~ /^def (\w+).*$/
      problem "Define method #{$1.inspect} in the class body, not at the top-level"
    end

    if line =~ /ENV.fortran/
      problem "Use `depends_on :fortran` instead of `ENV.fortran`"
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
  end

  def audit_conditional_dep(dep, condition, line)
    quoted_dep = quote_dep(dep)
    dep = Regexp.escape(dep.to_s)

    case condition
    when /if build\.include\? ['"]with-#{dep}['"]$/, /if build\.with\? ['"]#{dep}['"]$/
      problem %{Replace #{line.inspect} with "depends_on #{quoted_dep} => :optional"}
    when /unless build\.include\? ['"]without-#{dep}['"]$/, /unless build\.without\? ['"]#{dep}['"]$/
      problem %{Replace #{line.inspect} with "depends_on #{quoted_dep} => :recommended"}
    end
  end

  def quote_dep(dep)
    Symbol === dep ? dep.inspect : "'#{dep}'"
  end

  def audit_check_output warning_and_description
    return unless warning_and_description
    warning, description = *warning_and_description
    problem "#{warning}\n#{description}"
  end

  def audit_installed
    audit_check_output(check_manpages)
    audit_check_output(check_infopages)
    audit_check_output(check_jars)
    audit_check_output(check_non_libraries)
    audit_check_output(check_non_executables(f.bin))
    audit_check_output(check_generic_executables(f.bin))
    audit_check_output(check_non_executables(f.sbin))
    audit_check_output(check_generic_executables(f.sbin))
  end

  def audit
    audit_file
    audit_specs
    audit_urls
    audit_deps
    audit_conflicts
    audit_patches
    audit_text
    text.split("\n").each_with_index { |line, lineno| audit_line(line, lineno) }
    audit_installed
  end

  private

  def problem p, options={}
    return if options[:whitelist].to_a.include? f.name
    @problems << p
  end
end

class ResourceAuditor
  attr_reader :problems
  attr_reader :version, :checksum, :using, :specs, :url

  def initialize(resource)
    @version  = resource.version
    @checksum = resource.checksum
    @url      = resource.url
    @using    = resource.using
    @specs    = resource.specs
    @problems = []
  end

  def audit
    audit_version
    audit_checksum
    audit_download_strategy
    self
  end

  def audit_version
    if version.nil?
      problem "missing version"
    elsif version.to_s.empty?
      problem "version is set to an empty string"
    elsif not version.detected_from_url?
      version_text = version
      version_url = Version.detect(url, specs)
      if version_url.to_s == version_text.to_s && version.instance_of?(Version)
        problem "version #{version_text} is redundant with version scanned from URL"
      end
    end

    if version.to_s =~ /^v/
      problem "version #{version} should not have a leading 'v'"
    end
  end

  def audit_checksum
    return unless checksum

    case checksum.hash_type
    when :md5
      problem "MD5 checksums are deprecated, please use SHA1 or SHA256"
      return
    when :sha1   then len = 40
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
    return unless using

    url_strategy   = DownloadStrategyDetector.detect(url)
    using_strategy = DownloadStrategyDetector.detect('', using)

    if url_strategy == using_strategy
      problem "redundant :using specification in URL"
    end
  end

  def problem text
    @problems << text
  end
end
