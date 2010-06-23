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
  problems = []
  unless `grep "# depends_on 'cmake'" "#{f.path}"`.strip.empty?
    problems << " * Commented cmake support still in #{f.name}"
  end

  unless `grep "\?use_mirror=" "#{f.path}"`.strip.empty?
    problems << " * Remove 'use_mirror' from url for #{f.name}"
  end

  unless problems.empty?
    puts "#{f.name}:"
    puts problems * '\n'
    puts
  end
end
