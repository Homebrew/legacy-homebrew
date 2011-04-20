require 'formula'
require 'utils'

# Use "brew audit --strict" to enable even stricter checks.

def strict?
  ARGV.flag? "--strict"
end

def ff
  return Formula.all if ARGV.named.empty?
  return ARGV.formulae
end

def audit_formula_text name, text
  problems = []

  if text =~ /<Formula/
    problems << " * Use a space in class inheritance: class Foo < Formula"
  end if strict?

  # Commented-out cmake support from default template
  if (text =~ /# depends_on 'cmake'/) or (text =~ /# system "cmake/)
    problems << " * Commented cmake support found."
  end

  # 2 (or more in an if block) spaces before depends_on, please
  if text =~ /^\ ?depends_on/
    problems << " * Check indentation of 'depends_on'."
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
  if text =~ /(system|inreplace|gsub!|change_make_var!) .* ['"]#\{(\w+)\}['"]/
    problems << " * Don't need to interpolate \"#{$2}\" with #{$1}"
  end

  # Check for string concatenation; prefer interpolation
  if text =~ /(#\{\w+\s*\+\s*['"][^}]+\})/
    problems << " * Try not to concatenate paths in string interpolation:\n   #{$1}"
  end

  # Prefer formula path shortcuts in Pathname+
  if text =~ %r{\(\s*(prefix\s*\+\s*(['"])(bin|include|lib|libexec|sbin|share))}
    problems << " * \"(#{$1}...#{$2})\" should be \"(#{$3}+...)\""
  end

  if text =~ %r[((man)\s*\+\s*(['"])(man[1-8])(['"]))]
    problems << " * \"#{$1}\" should be \"#{$4}\""
  end

  # Prefer formula path shortcuts in strings
  if text =~ %r[(\#\{prefix\}/(bin|include|lib|libexec|sbin|share))]
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

  # Empty checksums
  if text =~ /md5\s+(\'\'|\"\")/
    problems << " * md5 is empty"
  end

  if text =~ /sha1\s+(\'\'|\"\")/
    problems << " * sha1 is empty"
  end

  # Commented-out depends_on
  if text =~ /#\s*depends_on\s+(.+)\s*$/
    problems << " * Commented-out dep #{$1}."
  end

  # No trailing whitespace, please
  if text =~ /(\t|[ ])+$/
    problems << " * Trailing whitespace was found."
  end

  if text =~ /if\s+ARGV\.include\?\s+'--HEAD'/
    problems << " * Use \"if ARGV.build_head?\" instead"
  end

  if text =~ /make && make/
    problems << " * Use separate make calls."
  end

  if text =~ /^\t/
    problems << " * Use spaces instead of tabs for indentation"
  end if strict?

  # Formula depends_on gfortran
  if text =~ /^\s*depends_on\s*(\'|\")gfortran(\'|\").*/
    problems << " * Use ENV.fortran during install instead of depends_on 'gfortran'"
  end unless name == "gfortran" # Gfortran itself has this text in the caveats

  # xcodebuild should specify SYMROOT
  if text =~ /xcodebuild/ and not text =~ /SYMROOT=/
    problems << " * xcodebuild should be passed an explicit \"SYMROOT\""
  end if strict?

  return problems
end

def audit_formula_options f, text
  problems = []

  # Find possible options
  options = []
  text.scan(/ARGV\.include\?[ ]*\(?(['"])(.+?)\1/) { |m| options << m[1] }
  options.reject! {|o| o.include? "#"}
  options.uniq!

  # Find documented options
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
      next if o == '--HEAD'
      problems << " * Option #{o} is not documented" unless documented_options.include? o
    end
  end

  if documented_options.length > 0
    documented_options.each do |o|
      problems << " * Option #{o} is unused" unless options.include? o
    end
  end

  return problems
end

def audit_formula_urls f
  problems = []

  unless f.homepage =~ %r[^https?://]
    problems << " * The homepage should start with http or https."
  end

  urls = [(f.url rescue nil), (f.head rescue nil)].reject {|p| p.nil?}

  # Check SourceForge urls
  urls.each do |p|
    # Is it a filedownload (instead of svnroot)
    next if p =~ %r[/svnroot/]
    next if p =~ %r[svn\.sourceforge]

    # Is it a sourceforge http(s) URL?
    next unless p =~ %r[^http?://.*\bsourceforge\.]

    if p =~ /\?use_mirror=/
      problems << " * Update this url (don't use ?use_mirror)."
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

  # Check Debian urls
  urls.each do |p|
    next unless p =~ %r[/debian/pool/]

    unless p =~ %r[^http://mirrors\.kernel\.org/debian/pool/]
      problems << " * \"mirrors.kernel.org\" is the preferred mirror for debian software."
    end
  end if strict?

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
  # We allow non-Homebrew installs whenenever possible.
  f.deps.each do |d|
    begin
      dep_f = Formula.factory d
    rescue
      problems << " * Can't find dependency \"#{d}\"."
    end

    case d
    when "git"
      problems << " * Don't use Git as a dependency; we allow non-Homebrew git installs."
    end
  end

  # Google Code homepages should end in a slash
  if f.homepage =~ %r[^https?://code\.google\.com/p/[^/]+[^/]$]
    problems << " * Google Code homepage should end with a slash."
  end

  return problems
end

def audit_formula_caveats f
  problems = []

  if f.caveats.to_s =~ /^\s*\$\s+/
    problems << " * caveats should not use '$' prompts in multiline commands."
  end if strict?

  return problems
end

module Homebrew extend self
  def audit
    ff.each do |f|
      problems = []
      problems += audit_formula_instance f
      problems += audit_formula_urls f
      problems += audit_formula_caveats f

      perms = File.stat(f.path).mode
      if perms.to_s(8) != "100644"
        problems << " * permissions wrong; chmod 644 #{f.path}"
      end

      text = ""
      File.open(f.path, "r") { |afile| text = afile.read }

      # DATA with no __END__
      if (text =~ /\bDATA\b/) and not (text =~ /^\s*__END__\s*$/)
        problems << " * 'DATA' was found, but no '__END__'"
      end

      problems += [' * invalid or missing version'] if f.version.to_s.empty?

      # Don't try remaining audits on text in __END__
      text_without_patch = (text.split("__END__")[0]).strip()

      problems += audit_formula_text(f.name, text_without_patch)
      problems += audit_formula_options(f, text_without_patch)

      unless problems.empty?
        puts "#{f.name}:"
        puts problems * "\n"
        puts
      end
    end
  end
end
