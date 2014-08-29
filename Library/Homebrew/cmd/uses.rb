require 'formula'

# `brew uses foo bar` returns formulae that use both foo and bar
# If you want the union, run the command twice and concatenate the results.
# The intersection is harder to achieve with shell tools.

module Homebrew
  def uses
    raise FormulaUnspecifiedError if ARGV.named.empty?

    used_formulae = ARGV.formulae
    formulae = (ARGV.include? "--installed") ? Formula.installed : Formula
    recursive = ARGV.flag? "--recursive"

    uses = formulae.select do |f|
      used_formulae.all? do |ff|
        if recursive
          f.recursive_dependencies.any? { |dep| dep.name == ff.name } ||
            f.recursive_requirements.any? { |req| req.name == ff.name }
        else
          f.deps.any? { |dep| dep.name == ff.name } ||
            f.requirements.any? { |req| req.name == ff.name }
        end
      end
    end

    puts_columns uses.map(&:name)
  end
end
