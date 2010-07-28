require 'formula'
require 'utils'

def ff
  return Formula.all if ARGV.named.empty?
  return ARGV.formulae
end

ff.each do |f|
  text = ""
  File.open(f.path, "r") { |afile| text = afile.read }

  problems = []
  if /# depends_on 'cmake'/ =~ text
    problems << " * Commented cmake support found."
  end

  if /\?use_mirror=/ =~ text
    problems << " * Remove 'use_mirror' from url."
  end

  # 2 (or more, if in an if block) spaces before depends_on, please
  if /^\ ?depends_on/ =~ text
    problems << " * Check indentation of 'depends_on'."
  end

  if /(#\{\w+\s*\+\s*['"][^}]+\})/ =~ text
    problems << " * Try not to concatenate paths in string interpolation:\n   #{$1}"
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
