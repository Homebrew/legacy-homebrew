require 'formula'

# `brew uses foo bar` now returns formula that use both foo and bar
# Rationale: If you want the union just run the command twice and
# concatenate the results.
# The intersection is harder to achieve with shell tools.

module Homebrew extend self
  def uses
    raise FormulaUnspecifiedError if ARGV.named.empty?

    uses = Formula.select do |f|
      ARGV.formulae.all? do |ff|
        if ARGV.flag? '--recursive'
          f.recursive_dependencies.any? { |dep| dep.name == ff.name }
        else
          f.deps.any? { |dep| dep.name == ff.name }
        end
      end
    end

    if ARGV.include? "--installed"
      uses = uses.select { |f| Formula.installed.include? f }
    end

    puts_columns uses.map(&:to_s).sort
  end
end
