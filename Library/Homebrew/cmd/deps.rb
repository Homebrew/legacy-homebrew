require 'formula'

def recursive_deps_tree f, level
  f.deps.each do |dep|
    dep = Formula.factory(dep)
    puts "> "*level+"#{dep}#{'*' if dep.installed?}"
    recursive_deps_tree(dep, level+1)
  end
end

module Homebrew extend self
  def deps
    if ARGV.include? '--all'
      Formula.each do |f|
        puts "#{f.name}: #{f.deps*' '}"
      end
    elsif ARGV.include? '--tree'
      ARGV.formulae.each do |f|
        puts f
        recursive_deps_tree(f, 1)
        puts
      end
    else
      all_deps = ARGV.formulae.map{ |f| ARGV.one? ? f.deps : f.recursive_deps }.intersection
      all_deps.sort! unless ARGV.include? "-n"
      all_deps.each do |dep|
        puts "#{dep}#{'*' if Formula.factory(dep).installed?}"
      end
    end
  end
end

class Array
  def intersection
    a = []
    each{ |b| a |= b }
    each{ |c| a &= c }
    a
  end
end
