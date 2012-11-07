require 'formula'
require 'rack'

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
    end.map{ |f| f.to_s}.sort

    if ARGV.include? "--installed"
      installed = Rack.all_fnames
      puts_columns uses.select{ |f| installed.include?(f) }
    else
      puts_columns uses.sort, :star=>Rack.all_fnames
      oh1 "Legend:#{Tty.reset} * Installed. To show only those, use --installed." if $stdout.tty? and not uses.empty?
    end

  end
end
