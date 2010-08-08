require 'formula'
require 'utils'

def ff
  return Formula.all if ARGV.named.empty?
  return ARGV.formulae
end

ff.each do |f|
  text = ""
  problems = []

  File.open(f.path, "r") { |afile| text = afile.read }

  if text =~ /# depends_on 'cmake'/
    problems << " * Commented cmake support found."
  end

  if text =~ /\?use_mirror=/
    problems << " * Remove 'use_mirror' from url."
  end

  # 2 (or more, if in an if block) spaces before depends_on, please
  if text =~ /^\ ?depends_on/
    problems << " * Check indentation of 'depends_on'."
  end

  if text =~ /(#\{\w+\s*\+\s*['"][^}]+\})/
    problems << " * Try not to concatenate paths in string interpolation:\n   #{$1}"
  end

  # Don't complain about spaces in patches
  split_patch = (text.split("__END__")[0]).strip()
  if split_patch =~ /[ ]+$/
    problems << " * Trailing whitespace was found."
  end

  aliases = Formula.aliases
  f.deps.select {|d| aliases.include? d}.each do |d|
    problems << " * Dep #{d} is an alias; switch to the real name."
  end

  unless problems.empty?
    puts "#{f.name}:"
    puts problems * "\n"
    puts
  end
end
