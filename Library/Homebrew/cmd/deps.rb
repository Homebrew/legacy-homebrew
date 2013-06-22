require 'formula'

module Homebrew extend self
  def deps
    if ARGV.include? '--installed'
      puts_deps Formula.installed
    elsif ARGV.include? '--all'
      puts_deps Formula
    elsif ARGV.include? '--tree'
      raise FormulaUnspecifiedError if ARGV.named.empty?
      puts_deps_tree ARGV.formulae
    else
      raise FormulaUnspecifiedError if ARGV.named.empty?
      all_deps = ARGV.formulae.map do |f|
        ARGV.one? ? f.deps.default : f.recursive_dependencies
      end.intersection.map(&:name)
      all_deps.sort! unless ARGV.include? "-n"
      puts all_deps
    end
  end

  def puts_deps(formulae)
    formulae.each { |f| puts "#{f.name}: #{f.deps*' '}" }
  end

  def puts_deps_tree(formulae)
    formulae.each do |f|
      puts f.name
      recursive_deps_tree(f, 1)
      puts
    end
  end

  def recursive_deps_tree f, level
    f.deps.default.each do |dep|
      puts "|  "*(level-1)+"|- "+dep.to_s
      recursive_deps_tree(Formula.factory(dep), level+1)
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
