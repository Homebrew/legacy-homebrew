require 'formula'
require 'utils'
require 'superenv'
require 'formula_cellar_checks'

module Homebrew extend self
  def audit
    formula_count = 0
    problem_count = 0

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
    @text = path.open('r') { |f| f.read }
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
      problem "Dependency #{d} is an alias; use the canonical name."
    end

    # Check for things we don't like to depend on.
    # We allow non-Homebrew installs whenever possible.
    f.deps.each do |dep|
      begin
        dep_f = dep.to_formula
      rescue FormulaUnavailableError
        problem "Can't find dependency #{dep.name.inspect}."
        next
      end

      dep.options.reject do |opt|
        dep_f.build.has_option?(opt.name)
      end.each do |opt|
        problem "Dependency #{dep} does not define option #{opt.name.inspect}"
      end

      case dep.name
      when *BUILD_TIME_DEPS
        next if dep.build?
        next if dep.name == 'autoconf' && f.name =~ /automake/
        next if dep.name == 'libtool' && %w{imagemagick libgphoto2 libp11}.any? { |n| f.name == n }
        next if dep.name =~ /autoconf|pkg-config/ && f.name == 'ruby-build'

        problem %{#{dep} dependency should be "depends_on '#{dep}' => :build"}
      when "git", "ruby", "emacs", "mercurial"
        problem <<-EOS.undent
          Don't use #{dep} as a dependency. We allow non-Homebrew
          #{dep} installations.
          EOS
      when 'python', 'python2', 'python3'
        problem <<-EOS.undent
          Don't use #{dep} as a dependency (string).
             We have special `depends_on :python` (or :python2 or :python3 )
             that works with brewed and system Python and allows us to support
             bindings for 2.x and 3.x in parallel and much more.
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
        Formula.factory(c.name)
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
      next unless p =~ %r[^https?://.*\bsourceforge\.]

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
    urls.select { |u| u =~ %r[https://.*/(?:tar|zip)ball/] and not u =~ %r[\.git$] }.each do |u|
      problem "Use /archive/ URLs for GitHub tarballs (url is #{u})."
    end

    if urls.any? { |u| u =~ /\.xz/ } && !f.deps.any? { |d| d.name == "xz" }
      problem "Missing a build-time dependency on 'xz'"
    end
  end

  def audit_specs
    problem "Head-only (no stable download)" if f.head_only?

    [:stable, :devel].each do |spec|
      s = f.send(spec)
      next if s.nil?

      if s.version.to_s.empty?
        problem "Invalid or missing #{spec} version"
      else
        version_text = s.version unless s.version.detected_from_url?
        version_url = Version.detect(s.url, s.specs)
        if version_url.to_s == version_text.to_s && s.version.instance_of?(Version)
          problem "#{spec} version #{version_text} is redundant with version scanned from URL"
        end
      end

      if s.version.to_s =~ /^v/
        problem "#{spec} version #{s.version} should not have a leading 'v'"
      end

      cksum = s.checksum
      next if cksum.nil?

      case cksum.hash_type
      when :md5
        problem "md5 checksums are deprecated, please use sha1 or sha256"
        next
      when :sha1   then len = 40
      when :sha256 then len = 64
      end

      if cksum.empty?
        problem "#{cksum.hash_type} is empty"
      else
        problem "#{cksum.hash_type} should be #{len} characters" unless cksum.hexdigest.length == len
        problem "#{cksum.hash_type} contains invalid characters" unless cksum.hexdigest =~ /^[a-fA-F0-9]+$/
        problem "#{cksum.hash_type} should be lowercase" unless cksum.hexdigest == cksum.hexdigest.downcase
      end
    end

    # Check for :using that is already detected from the url
    @specs.each do |s|
      next if s.using.nil?

      url_strategy = DownloadStrategyDetector.detect(s.url)
      using_strategy = DownloadStrategyDetector.detect('', s.using)

      problem "redundant :using specification in url or head" if url_strategy == using_strategy
    end
  end

  def audit_patches
    Patches.new(f.patches).select(&:external?).each do |p|
      case p.url
      when %r[raw\.github\.com], %r[gist\.github\.com/raw]
        unless p.url =~ /[a-fA-F0-9]{40}/
          problem "GitHub/Gist patches should specify a revision:\n#{p.url}"
        end
      when %r[macports/trunk]
        problem "MacPorts patches should specify a revision instead of trunk:\n#{p.url}"
      end
    end
  end

  def audit_text
    if text =~ /<(Formula|AmazonWebServicesFormula|ScriptFileFormula|GithubGistFormula)/
      problem "Use a space in class inheritance: class Foo < #{$1}"
    end

    # Commented-out cmake support from default template
    if (text =~ /# system "cmake/)
      problem "Commented cmake call found"
    end

    # Comments from default template
    if (text =~ /# PLEASE REMOVE/)
      problem "Please remove default template comments"
    end
    if (text =~ /# if this fails, try separate make\/make install steps/)
      problem "Please remove default template comments"
    end
    if (text =~ /# if your formula requires any X11\/XQuartz components/)
      problem "Please remove default template comments"
    end
    if (text =~ /# if your formula's build system can't parallelize/)
      problem "Please remove default template comments"
    end

    # FileUtils is included in Formula
    if text =~ /FileUtils\.(\w+)/
      problem "Don't need 'FileUtils.' before #{$1}."
    end

    # Check for long inreplace block vars
    if text =~ /inreplace .* do \|(.{2,})\|/
      problem "\"inreplace <filenames> do |s|\" is preferred over \"|#{$1}|\"."
    end

    # Check for string interpolation of single values.
    if text =~ /(system|inreplace|gsub!|change_make_var!).*[ ,]"#\{([\w.]+)\}"/
      problem "Don't need to interpolate \"#{$2}\" with #{$1}"
    end

    # Check for string concatenation; prefer interpolation
    if text =~ /(#\{\w+\s*\+\s*['"][^}]+\})/
      problem "Try not to concatenate paths in string interpolation:\n   #{$1}"
    end

    # Prefer formula path shortcuts in Pathname+
    if text =~ %r{\(\s*(prefix\s*\+\s*(['"])(bin|include|libexec|lib|sbin|share)[/'"])}
      problem "\"(#{$1}...#{$2})\" should be \"(#{$3}+...)\""
    end

    if text =~ %r[((man)\s*\+\s*(['"])(man[1-8])(['"]))]
      problem "\"#{$1}\" should be \"#{$4}\""
    end

    # Prefer formula path shortcuts in strings
    if text =~ %r[(\#\{prefix\}/(bin|include|libexec|lib|sbin|share))]
      problem "\"#{$1}\" should be \"\#{#{$2}}\""
    end

    if text =~ %r[((\#\{prefix\}/share/man/|\#\{man\}/)(man[1-8]))]
      problem "\"#{$1}\" should be \"\#{#{$3}}\""
    end

    if text =~ %r[((\#\{share\}/(man)))[/'"]]
      problem "\"#{$1}\" should be \"\#{#{$3}}\""
    end

    if text =~ %r[(\#\{prefix\}/share/(info|man))]
      problem "\"#{$1}\" should be \"\#{#{$2}}\""
    end

    # Commented-out depends_on
    if text =~ /#\s*depends_on\s+(.+)\s*$/
      problem "Commented-out dep #{$1}"
    end

    # No trailing whitespace, please
    if text =~ /[\t ]+$/
      problem "Trailing whitespace was found"
    end

    if text =~ /if\s+ARGV\.include\?\s+'--(HEAD|devel)'/
      problem "Use \"if ARGV.build_#{$1.downcase}?\" instead"
    end

    if text =~ /make && make/
      problem "Use separate make calls"
    end

    if text =~ /^[ ]*\t/
      problem "Use spaces instead of tabs for indentation"
    end

    # xcodebuild should specify SYMROOT
    if text =~ /system\s+['"]xcodebuild/ and not text =~ /SYMROOT=/
      problem "xcodebuild should be passed an explicit \"SYMROOT\""
    end

    if text =~ /ENV\.x11/
      problem "Use \"depends_on :x11\" instead of \"ENV.x11\""
    end

    # Avoid hard-coding compilers
    if text =~ %r{(system|ENV\[.+\]\s?=)\s?['"](/usr/bin/)?(gcc|llvm-gcc|clang)['" ]}
      problem "Use \"\#{ENV.cc}\" instead of hard-coding \"#{$3}\""
    end

    if text =~ %r{(system|ENV\[.+\]\s?=)\s?['"](/usr/bin/)?((g|llvm-g|clang)\+\+)['" ]}
      problem "Use \"\#{ENV.cxx}\" instead of hard-coding \"#{$3}\""
    end

    if text =~ /system\s+['"](env|export)/
      problem "Use ENV instead of invoking '#{$1}' to modify the environment"
    end

    if text =~ /version == ['"]HEAD['"]/
      problem "Use 'build.head?' instead of inspecting 'version'"
    end

    if text =~ /build\.include\?\s+['"]\-\-(.*)['"]/
      problem "Reference '#{$1}' without dashes"
    end

    if text =~ /build\.with\?\s+['"]-?-?with-(.*)['"]/
      problem "No double 'with': Use `build.with? '#{$1}'` to check for \"--with-#{$1}\""
    end

    if text =~ /build\.without\?\s+['"]-?-?without-(.*)['"]/
      problem "No double 'without': Use `build.without? '#{$1}'` to check for \"--without-#{$1}\""
    end

    if text =~ /ARGV\.(?!(debug\?|verbose\?|find[\(\s]))/
      problem "Use build instead of ARGV to check options"
    end

    if text =~ /def options/
      problem "Use new-style option definitions"
    end

    if text =~ /MACOS_VERSION/
      problem "Use MacOS.version instead of MACOS_VERSION"
    end

    cats = %w{leopard snow_leopard lion mountain_lion}.join("|")
    if text =~ /MacOS\.(?:#{cats})\?/
      problem "\"#{$&}\" is deprecated, use a comparison to MacOS.version instead"
    end

    if text =~ /skip_clean\s+:all/
      problem "`skip_clean :all` is deprecated; brew no longer strips symbols"
    end

    if text =~ /depends_on [A-Z][\w:]+\.new$/
      problem "`depends_on` can take requirement classes instead of instances"
    end

    if text =~ /^def (\w+).*$/
      problem "Define method #{$1.inspect} in the class body, not at the top-level"
    end

    if text =~ /ENV.fortran/
      problem "Use `depends_on :fortran` instead of `ENV.fortran`"
    end
  end

  def audit_python
    if text =~ /(def\s*)?which_python/
      problem "Replace `which_python` by `python.xy`, which returns e.g. 'python2.7'"
    end

    if text =~ /which\(?["']python/
      problem "Don't locate python with `which 'python'`, use `python.binary` instead"
    end

    if text =~ /LanguageModuleDependency.new\s?\(\s?:python/
      problem <<-EOS.undent
        Python: Replace `LanguageModuleDependency.new(:python,'PyPi-name','module')`
           by the new `depends_on :python => ['module' => 'PyPi-name']`
      EOS
    end

    # Checks that apply only to code in def install
    if text =~ /(\s*)def\s+install((.*\n)*?)(\1end)/
      install_body = $2

      if install_body =~ /system\(?\s*['"]python/
        problem "Instead of `system 'python', ...`, call `system python, ...`"
      end

      if text =~ /system\(?\s*python\.binary/
        problem "Instead of `system python.binary, ...`, call `system python, ...`"
      end
    end

    # Checks that apply only to code in def caveats
    if text =~ /(\s*)def\s+caveats((.*\n)*?)(\1end)/ || /(\s*)def\s+caveats;(.*?)end/
      caveats_body = $2
        if caveats_body =~ /[ \{=](python[23]?)\.(.*\w)/
          # So if in the body of caveats there is a `python.whatever` called,
          # check that there is a guard like `if python` or similiar:
          python = $1
          method = $2
          unless caveats_body =~ /(if python[23]?)|(if build\.with\?\s?\(?['"]python)|(unless build.without\?\s?\(?['"]python)/
          problem "Please guard `#{python}.#{method}` like so `#{python}.#{method} if #{python}`"
        end
      end
    end

    if f.requirements.any?{ |r| r.kind_of?(PythonInstalled) }
      # Don't check this for all formulae, because some are allowed to set the
      # PYTHONPATH. E.g. python.rb itself needs to set it.
      if text =~ /ENV\.append.*PYTHONPATH/ || text =~ /ENV\[['"]PYTHONPATH['"]\]\s*=[^=]/
        problem "Don't set the PYTHONPATH, instead declare `depends_on :python`"
      end
    else
      # So if there is no PythonInstalled requirement, we can check if the
      # formula still uses python and should add a `depends_on :python`
      unless f.name.to_s =~ /(pypy[0-9]*)|(python[0-9]*)/
        if text =~ /system.["' ]?python([0-9"'])?/
          problem "If the formula uses Python, it should declare so by `depends_on :python#{$1}`"
        end
        if text =~ /setup\.py/
          problem <<-EOS.undent
            If the formula installs Python bindings you should declare `depends_on :python[3]`"
          EOS
        end
      end
    end

    # Todo:
    # The python do ... end block is possibly executed twice. Once for
    # python 2.x and once for 3.x. So if a `system 'make'` is called, a
    # `system 'make clean'` should also be called at the end of the block.

  end

  def audit_check_output warning_and_description
    return unless warning_and_description
    warning, _ = *warning_and_description
    problem warning
  end

  def audit_installed
    audit_check_output(check_manpages)
    audit_check_output(check_infopages)
    audit_check_output(check_jars)
    audit_check_output(check_non_libraries)
    audit_check_output(check_non_executables(f.bin))
    audit_check_output(check_non_executables(f.sbin))
  end

  def audit
    audit_file
    audit_specs
    audit_urls
    audit_deps
    audit_conflicts
    audit_patches
    audit_text
    audit_python
    audit_installed
  end

  private

  def problem p
    @problems << p
  end
end
