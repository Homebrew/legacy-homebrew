require 'formula'
require 'utils'

def ff
  if ARGV.named.empty?
    stuff = []
    Formulary.read_all do |name,k|
      stuff << Formula.factory(name)
    end
    return stuff
  else
    return ARGV.formulae
  end
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

  if /(#\{\w+\s*\+\s*['"][^}]+\})/ =~ text
    problems << " * Try not to concatenate paths in string interpolation:\n   #{$1}"
  end

  unless problems.empty?
    puts "#{f.name}:"
    puts problems * "\n"
    puts
  end
end
