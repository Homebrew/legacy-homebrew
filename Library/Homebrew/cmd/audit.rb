require 'formula'
require 'utils'
require 'extend/ENV'

module Homebrew extend self
  def audit
    formula_count = 0
    problem_count = 0

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
    /.+\z/ =~ @text
  end
end

class FormulaAuditor
  attr :f
  attr :text
  attr :problems, true

  BUILD_TIME_DEPS = %W[
    autoconf
    automake
    boost-build
    bsdmake
    cmake
    imake
    libtool
    pkg-config
    scons
    smake
  ]

  def initialize f
    @f = f
    @problems = []
    @text = f.text.without_patch

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

    if f.text.has_trailing_newline?
      problem "File should end with a newline"
    end
  end

  def audit_deps
    problems = []

    # Don't depend_on aliases; use full name
    aliases = Formula.aliases
    f.deps.select {|d| aliases.include? d}.each do |d|
      problem "Dependency #{d} is an alias; use the canonical name."
    end

    # Check for things we don't like to depend on.
    # We allow non-Homebrew installs whenever possible.
    f.deps.each do |d|
      begin
        dep_f = Formula.factory d
      rescue
        problem "Can't find dependency \"#{d}\"."
      end

      case d.name
      when "git", "python", "ruby", "emacs", "mysql", "postgresql", "mercurial"
        problem <<-EOS.undent
          Don't use #{d} as a dependency. We allow non-Homebrew
          #{d} installations.
          EOS
      when 'gfortran'
        problem "Use ENV.fortran during install instead of depends_on 'gfortran'"
      when 'open-mpi', 'mpich2'
        problem <<-EOS.undent
          There are multiple conflicting ways to install MPI. Use an MPIDependency:
            depends_on MPIDependency.new(<lang list>)
          Where <lang list> is a comma delimited list that can include:
            :cc, :cxx, :f90, :f77
          EOS
      end
    end
  end


  def audit_urls
    unless f.homepage =~ %r[^https?://]
      problem "The homepage should start with http or https."
    end

    # Google Code homepages should end in a slash
    if f.homepage =~ %r[^https?://code\.google\.com/p/[^/]+[^/]$]
      problem "Google Code homepage should end with a slash."
    end

    urls = [(f.stable.url rescue nil), (f.devel.url rescue nil), (f.head.url rescue nil)].compact

    # Check GNU urls; doesn't apply to mirrors
    if urls.any? { |p| p =~ %r[^(https?|ftp)://(.+)/gnu/] }
      problem "\"ftpmirror.gnu.org\" is preferred for GNU software."
    end

    # the rest of the checks apply to mirrors as well
    urls.concat([(f.stable.mirrors rescue nil), (f.devel.mirrors rescue nil)].flatten.compact)

    # Check SourceForge urls
    urls.each do |p|
      # Is it a filedownload (instead of svnroot)
      next if p =~ %r[/svnroot/]
      next if p =~ %r[svn\.sourceforge]

      # Is it a sourceforge http(s) URL?
      next unless p =~ %r[^https?://.*\bsourceforge\.]

      if p =~ /(\?|&)use_mirror=/
        problem "Update this url (don't use #{$1}use_mirror)."
      end

      if p =~ /\/download$/
        problem "Update this url (don't use /download)."
      end

      if p =~ %r[^http://prdownloads\.]
        problem "Update this url (don't use prdownloads)."
      end

      if p =~ %r[^http://\w+\.dl\.]
        problem "Update this url (don't use specific dl mirrors)."
      end
    end

    # Check for git:// urls; https:// is preferred.
    if urls.any? { |p| p =~ %r[^git://github\.com/] }
      problem "Use https:// URLs for accessing GitHub repositories."
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
        version_url = Version.parse(s.url)
        if version_url == version_text
          problem "#{spec} version #{version_text} is redundant with version scanned from URL"
        end
      end

      cksum = s.checksum
      next if cksum.nil?

      len = case cksum.hash_type
        when :md5 then 32
        when :sha1 then 40
        when :sha256 then 64
        end

      if cksum.empty?
        problem "#{cksum.hash_type} is empty"
      else
        problem "#{cksum.hash_type} should be #{len} characters" unless cksum.hexdigest.length == len
        problem "#{cksum.hash_type} contains invalid characters" unless cksum.hexdigest =~ /^[a-fA-F0-9]+$/
        problem "#{cksum.hash_type} should be lowercase" unless cksum.hexdigest == cksum.hexdigest.downcase
      end
    end
  end

  def audit_patches
    # Some formulae use ENV in patches, so set up an environment
    ENV.extend(HomebrewEnvExtension)
    ENV.setup_build_environment

    Patches.new(f.patches).select { |p| p.external? }.each do |p|
      case p.url
      when %r[raw\.github\.com], %r[gist\.github\.com/raw]
        problem "Using raw GitHub URLs is not recommended:\n#{p.url}"
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
    if (text =~ /# depends_on 'cmake'/) or (text =~ /# system "cmake/)
      problem "Commented cmake support found."
    end

    # 2 (or more in an if block) spaces before depends_on, please
    if text =~ /^\ ?depends_on/
      problem "Check indentation of 'depends_on'."
    end

    # build tools should be flagged properly
    if text =~ /depends_on ['"](#{BUILD_TIME_DEPS*'|'})['"]$/
      problem "#{$1} dependency should be \"depends_on '#{$1}' => :build\""
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
    if text =~ /(system|inreplace|gsub!|change_make_var!) .* ['"]#\{(\w+(\.\w+)?)\}['"]/
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
      problem "Commented-out dep #{$1}."
    end

    # No trailing whitespace, please
    if text =~ /(\t|[ ])+$/
      problem "Trailing whitespace was found."
    end

    if text =~ /if\s+ARGV\.include\?\s+'--(HEAD|devel)'/
      problem "Use \"if ARGV.build_#{$1.downcase}?\" instead"
    end

    if text =~ /make && make/
      problem "Use separate make calls."
    end

    if text =~ /^[ ]*\t/
      problem "Use spaces instead of tabs for indentation"
    end

    # xcodebuild should specify SYMROOT
    if text =~ /system\s+['"]xcodebuild/ and not text =~ /SYMROOT=/
      problem "xcodebuild should be passed an explicit \"SYMROOT\""
    end

    # Avoid hard-coding compilers
    if text =~ %r[(system|ENV\[.+\]\s?=)\s?['"](/usr/bin/)?(gcc|llvm-gcc|clang)['" ]]
      problem "Use \"\#{ENV.cc}\" instead of hard-coding \"#{$3}\""
    end

    if text =~ %r[(system|ENV\[.+\]\s?=)\s?['"](/usr/bin/)?((g|llvm-g|clang)\+\+)['" ]]
      problem "Use \"\#{ENV.cxx}\" instead of hard-coding \"#{$3}\""
    end

    if text =~ /system\s+['"](env|export)/
      problem "Use ENV instead of invoking '#{$1}' to modify the environment"
    end

    if text =~ /version == ['"]HEAD['"]/
      problem "Use 'build.head?' instead of inspecting 'version'"
    end

    if text =~ /ARGV\.(?!(debug|verbose)\?)/
      problem "Use build instead of ARGV to check options."
    end

    if text =~ /def options/
      problem "Use new-style option definitions."
    end
  end

  def audit
    audit_file
    audit_specs
    audit_urls
    audit_deps
    audit_patches
    audit_text
  end

  private

  def problem p
    @problems << p
  end
end
