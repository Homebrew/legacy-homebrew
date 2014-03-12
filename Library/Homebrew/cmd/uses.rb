require 'formula'

# `brew uses foo bar` returns formulae that use both foo and bar
# If you want the union, run the command twice and concatenate the results.
# The intersection is harder to achieve with shell tools.

module Homebrew extend self
  def test_dependencies f, ff
    if ARGV.flag? '--recursive'
      f.recursive_dependencies.any? { |dep| dep.name == ff.name } || f.recursive_requirements.any? { |req| req.name == ff.name }
    else
      f.deps.any? { |dep| dep.name == ff.name } || f.requirements.any? { |req| req.name == ff.name }
    end
  end

  def uses
    raise FormulaUnspecifiedError if ARGV.named.empty?

    used_formulae = ARGV.formulae
    formulae = (ARGV.include? "--installed") ? Formula.installed : Formula

    uses = []
    if ARGV.include? '--or'
      formulae.each do |f|
        uses << f.to_s if used_formulae.any? do |ff|
          test_dependencies f, ff
        end
      end
    else
      formulae.each do |f|
        uses << f.to_s if used_formulae.all? do |ff|
          test_dependencies f, ff
        end
      end
    end

    puts_columns uses
  end
end
