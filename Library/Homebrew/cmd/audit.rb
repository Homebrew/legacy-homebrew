require 'formula'
require 'utils'
require 'extend/ENV'

# Some formulae use ENV in patches, so set up an environment
ENV.extend(HomebrewEnvExtension)
ENV.setup_build_environment

class Module
  def redefine_const(name, value)
    __send__(:remove_const, name) if const_defined?(name)
    const_set(name, value)
  end
end

def ff
  return Formula.all if ARGV.named.empty?
  return ARGV.formulae
end

def audit_formula_text name, text
  problems = []

  if text =~ /<(Formula|AmazonWebServicesFormula|ScriptFileFormula|GithubGistFormula)/
    problems << " * Use a space in class inheritance: class Foo < #{$1}"
  end

  # Commented-out cmake support from default template
  if (text =~ /# depends_on 'cmake'/) or (text =~ /# system "cmake/)
    problems << " * Commented cmake support found."
  end

  # 2 (or more in an if block) spaces before depends_on, please
  if text =~ /^\ ?depends_on/
    problems << " * Check indentation of 'depends_on'."
  end

  # build tools should be flagged properly
  build_deps = %w{autoconf automake boost-build bsdmake
                  cmake imake libtool pkg-config scons smake}
  if text =~ /depends_on ['"](#{build_deps*'|'})['"]$/
    problems << " * #{$1} dependency should be \"depends_on '#{$1}' => :build\""
  end

  # FileUtils is included in Formula
  if text =~ /FileUtils\.(\w+)/
    problems << " * Don't need 'FileUtils.' before #{$1}."
  end

  # Check for long inreplace block vars
  if text =~ /inreplace .* do \|(.{2,})\|/
    problems << " * \"inreplace <filenames> do |s|\" is preferred over \"|#{$1}|\"."
  end

  # Check for string interpolation of single values.
  if text =~ /(system|inreplace|gsub!|change_make_var!) .* ['"]#\{(\w+(\.\w+)?)\}['"]/
    problems << " * Don't need to interpolate \"#{$2}\" with #{$1}"
  end

  # Check for string concatenation; prefer interpolation
  if text =~ /(#\{\w+\s*\+\s*['"][^}]+\})/
    problems << " * Try not to concatenate paths in string interpolation:\n   #{$1}"
  end

  # Prefer formula path shortcuts in Pathname+
  if text =~ %r{\(\s*(prefix\s*\+\s*(['"])(bin|include|libexec|lib|sbin|share)[/'"])}
    problems << " * \"(#{$1}...#{$2})\" should be \"(#{$3}+...)\""
  end

  if text =~ %r[((man)\s*\+\s*(['"])(man[1-8])(['"]))]
    problems << " * \"#{$1}\" should be \"#{$4}\""
  end

  # Prefer formula path shortcuts in strings
  if text =~ %r[(\#\{prefix\}/(bin|include|libexec|lib|sbin|share))]
    problems << " * \"#{$1}\" should be \"\#{#{$2}}\""
  end

  if text =~ %r[((\#\{prefix\}/share/man/|\#\{man\}/)(man[1-8]))]
    problems << " * \"#{$1}\" should be \"\#{#{$3}}\""
  end

  if text =~ %r[((\#\{share\}/(man)))[/'"]]
    problems << " * \"#{$1}\" should be \"\#{#{$3}}\""
  end

  if text =~ %r[(\#\{prefix\}/share/(info|man))]
    problems << " * \"#{$1}\" should be \"\#{#{$2}}\""
  end

  # Commented-out depends_on
  if text =~ /#\s*depends_on\s+(.+)\s*$/
    problems << " * Commented-out dep #{$1}."
  end

  # No trailing whitespace, please
  if text =~ /(\t|[ ])+$/
    problems << " * Trailing whitespace was found."
  end

  if text =~ /if\s+ARGV\.include\?\s+'--(HEAD|devel)'/
    problems << " * Use \"if ARGV.build_#{$1.downcase}?\" instead"
  end

  if text =~ /make && make/
    problems << " * Use separate make calls."
  end

  if text =~ /^[ ]*\t/
    problems << " * Use spaces instead of tabs for indentation"
  end

  # xcodebuild should specify SYMROOT
  if text =~ /system\s+['"]xcodebuild/ and not text =~ /SYMROOT=/
    problems << " * xcodebuild should be passed an explicit \"SYMROOT\""
  end

  # using ARGV.flag? for formula options is generally a bad thing
  if text =~ /ARGV\.flag\?/
    problems << " * Use 'ARGV.include?' instead of 'ARGV.flag?'"
  end

  # Avoid hard-coding compilers
  if text =~ %r[(system|ENV\[.+\]\s?=)\s?['"](/usr/bin/)?(gcc|llvm-gcc|clang)['" ]]
    problems << " * Use \"\#{ENV.cc}\" instead of hard-coding \"#{$3}\""
  end

  if text =~ %r[(system|ENV\[.+\]\s?=)\s?['"](/usr/bin/)?((g|llvm-g|clang)\+\+)['" ]]
    problems << " * Use \"\#{ENV.cxx}\" instead of hard-coding \"#{$3}\""
  end

  if text =~ /system\s+['"](env|export)/
    problems << " * Use ENV instead of invoking '#{$1}' to modify the environment"
  end

  if text =~ /version == ['"]HEAD['"]/
    problems << " * Use 'ARGV.build_head?' instead of inspecting 'version'"
  end

  return problems
end

INSTALL_OPTIONS = %W[
  --build-from-source
  --debug
  --devel
  --force
  --fresh
  --HEAD
  --ignore-dependencies
  --interactive
  --use-clang
  --use-gcc
  --use-llvm
  --verbose
].freeze

def audit_formula_options f, text
  problems = []

  # Textually find options checked for in the formula
  options = []
  text.scan(/ARGV\.include\?[ ]*\(?(['"])(.+?)\1/) { |m| options << m[1] }
  options.reject! {|o| o.include? "#"}
  options.uniq! # May be checked more than once

  # Find declared options
  begin
    opts = f.options
    documented_options = []
    opts.each{ |o| documented_options << o[0] }
    documented_options.reject! {|o| o.include? "="}
  rescue
    documented_options = []
  end

  if options.length > 0
    options.each do |o|
      next if o == '--HEAD' || o == '--devel'
      problems << " * Option #{o} is not documented" unless documented_options.include? o
    end
  end

  if documented_options.length > 0
    documented_options.each do |o|
      next if o == '--universal' and text =~ /ARGV\.build_universal\?/
      next if o == '--32-bit' and text =~ /ARGV\.build_32_bit\?/
      problems << " * Option #{o} is unused" unless options.include? o
      if INSTALL_OPTIONS.include? o
        problems << " * Option #{o} shadows an install option; should be renamed"
      end
    end
  end

  return problems
end

def audit_formula_patches f
  problems = []
  patches = Patches.new(f.patches)
  patches.each do |p|
    next unless p.external?
    case p.url
    when %r[raw\.github\.com], %r[gist\.github\.com/raw]
      problems << " * Using raw GitHub URLs is not recommended:"
      problems << "   #{p.url}"
    when %r[macports/trunk]
      problems << " * MacPorts patches should specify a revision instead of trunk:"
      problems << "   #{p.url}"
    end
  end
  return problems
end

def audit_formula_urls f
  problems = []

  unless f.homepage =~ %r[^https?://]
    problems << " * The homepage should start with http or https."
  end

  # Google Code homepages should end in a slash
  if f.homepage =~ %r[^https?://code\.google\.com/p/[^/]+[^/]$]
    problems << " * Google Code homepage should end with a slash."
  end

  urls = [(f.stable.url rescue nil), (f.devel.url rescue nil), (f.head.url rescue nil)].reject {|p| p.nil?}

  # Check GNU urls; doesn't apply to mirrors
  urls.each do |p|
    if p =~ %r[^(https?|ftp)://(.+)/gnu/]
      problems << " * \"ftpmirror.gnu.org\" is preferred for GNU software."
    end
  end

  # the rest of the checks apply to mirrors as well
  mirrors = [(f.stable.mirrors rescue []), (f.devel.mirrors rescue [])].flatten.reject { |m| m.nil? }
  urls.concat mirrors.map { |m| m[:url] }

  # Check SourceForge urls
  urls.each do |p|
    # Is it a filedownload (instead of svnroot)
    next if p =~ %r[/svnroot/]
    next if p =~ %r[svn\.sourceforge]

    # Is it a sourceforge http(s) URL?
    next unless p =~ %r[^https?://.*\bsourceforge\.]

    if p =~ /(\?|&)use_mirror=/
      problems << " * Update this url (don't use #{$1}use_mirror)."
    end

    if p =~ /\/download$/
      problems << " * Update this url (don't use /download)."
    end

    if p =~ %r[^http://prdownloads\.]
      problems << " * Update this url (don't use prdownloads)."
    end

    if p =~ %r[^http://\w+\.dl\.]
      problems << " * Update this url (don't use specific dl mirrors)."
    end
  end

  # Check for git:// urls; https:// is preferred.
  urls.each do |p|
    if p =~ %r[^git://github\.com/]
      problems << " * Use https:// URLs for accessing repositories on GitHub."
    end
  end

  return problems
end

def audit_formula_specs f
  problems = []

  [:stable, :devel].each do |spec|
    s = f.send(spec)
    next if s.nil?

    if s.version.to_s.empty?
      problems << " * invalid or missing #{spec} version"
    else
      version_text = s.version if s.explicit_version?
      version_url = Pathname.new(s.url).version
      if version_url == version_text
        problems << " * #{spec} version #{version_text} is redundant with version scanned from URL"
      end
    end

    cksum = s.checksum_type
    unless cksum.nil?
      hash = s.send(cksum).strip
      len = case cksum
      when :md5 then 32
      when :sha1 then 40
      when :sha256 then 64
      end

      if hash.empty?
        problems << " * #{cksum} is empty"
      else
        problems << " * #{cksum} should be #{len} characters" unless hash.length == len
        problems << " * #{cksum} contains invalid characters" unless hash =~ /^[a-fA-F0-9]+$/
        problems << " * #{cksum} should be lowercase" unless hash == hash.downcase
      end
    end
  end

  return problems
end

def audit_formula_instance f
  problems = []

  # Don't depend_on aliases; use full name
  aliases = Formula.aliases
  f.deps.select {|d| aliases.include? d}.each do |d|
    problems << " * Dep #{d} is an alias; switch to the real name."
  end

  # Check for things we don't like to depend on.
  # We allow non-Homebrew installs whenever possible.
  f.deps.each do |d|
    begin
      dep_f = Formula.factory d
    rescue
      problems << " * Can't find dependency \"#{d}\"."
    end

    case d.name
    when "git", "python", "ruby", "emacs", "mysql", "postgresql", "mercurial"
      problems << <<-EOS
 * Don't use #{d} as a dependency. We allow non-Homebrew
   #{d} installations.
EOS
    when 'gfortran'
      problems << " * Use ENV.fortran during install instead of depends_on 'gfortran'"
    end
  end

  return problems
end

# Formula extensions for auditing
class Formula
  def head_only?
    @head and @stable.nil?
  end

  def formula_text
    File.open(@path, "r") { |afile| return afile.read }
  end
end

module Homebrew extend self
  def audit
    errors = false

    brew_count = 0
    problem_count = 0

    ff.each do |f|
      # We need to do this in case the formula defines a patch that uses DATA.
      f.class.redefine_const :DATA, ""

      problems = []
      problems += [' * head-only formula'] if f.head_only?
      problems += audit_formula_instance f
      problems += audit_formula_urls f
      problems += audit_formula_patches f

      perms = File.stat(f.path).mode
      if perms.to_s(8) != "100644"
        problems << " * permissions wrong; chmod 644 #{f.path}"
      end

      text = f.formula_text

      # DATA with no __END__
      if (text =~ /\bDATA\b/) and not (text =~ /^\s*__END__\s*$/)
        problems << " * 'DATA' was found, but no '__END__'"
      end

      # files should end with a newline
      if text =~ /.+\z/
        problems << " * File should end with a newline"
      end

      # Don't try remaining audits on text in __END__
      text_without_patch = (text.split("__END__")[0]).strip()

      problems += audit_formula_text(f.name, text_without_patch)
      problems += audit_formula_options(f, text_without_patch)
      problems += audit_formula_specs(f)

      unless problems.empty?
        errors = true
        puts "#{f.name}:"
        puts problems * "\n"
        puts
        brew_count += 1
        problem_count += problems.select{ |p| p.start_with? ' *' }.size
      end
    end

    ofail "#{problem_count} problems in #{brew_count} brews" if errors
  end
end
