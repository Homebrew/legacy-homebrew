require 'formula'

def recursive_deps_tree f, level
  f.deps.each do |dep|
    puts "> "*level+dep.to_s
    recursive_deps_tree(Formula.factory(dep), level+1)
  end
end

module Homebrew extend self
  def deps
    if ARGV.include? '--installed'
        Formula.installed.each do |f|
          puts "#{f.name}: #{f.deps*' '}"
        end
    elsif ARGV.include? '--all'
      Formula.each do |f|
        puts "#{f.name}: #{f.deps*' '}"
      end
    elsif ARGV.include? '--tree'
      raise FormulaUnspecifiedError if ARGV.named.empty?
      ARGV.formulae.each do |f|
        puts f
        recursive_deps_tree(f, 1)
        puts
      end
    else
      raise FormulaUnspecifiedError if ARGV.named.empty?
      all_deps = ARGV.formulae.map do |f|
        ARGV.one? ? f.deps : f.recursive_dependencies
      end.intersection.map(&:name)
      all_deps.sort! unless ARGV.include? "-n"
      puts all_deps
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
