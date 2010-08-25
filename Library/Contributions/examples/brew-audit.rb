require 'formula'
require 'utils'

def ff
  return Formula.all if ARGV.named.empty?
  return ARGV.formulae
end

def audit_formula_text text
  problems = []

  # Commented-out cmake support from default template
  if text =~ /# depends_on 'cmake'/
    problems << " * Commented cmake support found."
  end

  # SourceForge URL madness
  if text =~ /\?use_mirror=/
    problems << " * Remove 'use_mirror' from url."
  end

  # 2 (or more, if in an if block) spaces before depends_on, please
  if text =~ /^\ ?depends_on/
    problems << " * Check indentation of 'depends_on'."
  end

  # FileUtils is included in Formula
  if text =~ /FileUtils\.(\w+)/
    problems << " * Don't need 'FileUtils.' before #{$1}."
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

  if text =~ %r[(\#\{prefix\}/share/(info|man))]
    problems << " * \"#{$1}\" should be \"\#{#{$2}}\""
  end

  # Empty checksums
  if text =~ /md5\s+\'\'/
    problems << " * md5 is empty"
  end

  # No trailing whitespace, please
  if text =~ /[ ]+$/
    problems << " * Trailing whitespace was found."
  end

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

def audit_formula_instance f
  problems = []

  # Don't depend_on aliases; use full name
  aliases = Formula.aliases
  f.deps.select {|d| aliases.include? d}.each do |d|
    problems << " * Dep #{d} is an alias; switch to the real name."
  end

  # Google Code homepages should end in a slash
  if f.homepage =~ %r[^https?://code\.google\.com/p/[^/]+[^/]$]
    problems << " * Google Code homepage should end with a slash."
  end

  return problems
end

def audit_some_formulae
  ff.each do |f|
    problems = []

    problems += audit_formula_instance f

    text = ""
    File.open(f.path, "r") { |afile| text = afile.read }

    # DATA with no __END__
    if (text =~ /\bDATA\b/) and not (text =~ /^\s*__END__\s*$/)
      problems << " * 'DATA' was found, but no '__END__'"
    end

    # Don't try remaining audits on text in __END__
    text_without_patch = (text.split("__END__")[0]).strip()

    problems += audit_formula_text(text_without_patch)
    problems += audit_formula_options(f, text_without_patch)

    unless problems.empty?
      puts "#{f.name}:"
      puts problems * "\n"
      puts
    end
  end
end

audit_some_formulae
