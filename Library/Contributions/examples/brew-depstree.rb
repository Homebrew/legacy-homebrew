require 'formula'

module Homebrew extend self
  def depstree
    ARGV.formulae.each do |f|
      puts f
      recursive_deps_tree(f, 1)
      puts
    end
  end

private
  def recursive_deps_tree(formula, level)
    formula.deps.each do |dep|
      puts "> "*level+dep
      recursive_deps_tree(Formula.factory(dep), level+1)
    end
  end
end

Homebrew.depstree
