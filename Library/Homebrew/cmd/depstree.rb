require 'formula'

module Homebrew extend self
  def depstree
  	formula=ARGV.formulae[0]
  	puts formula
    recursive_deps_tree(formula, 1)
   end

private
	def recursive_deps_tree(formula, level)
		formula.deps.each do |dep|
			puts "> "*level+dep
			recursive_deps_tree(Formula.factory(dep), level+1)
		end
	end
end