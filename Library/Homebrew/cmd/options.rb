require "formula"
require "options"

module Homebrew
  def options
    if ARGV.include? "--all"
      puts_options Formula.to_a
    elsif ARGV.include? "--installed"
      puts_options Formula.installed
    else
      raise FormulaUnspecifiedError if ARGV.named.empty?
      puts_options ARGV.formulae
    end
  end

  def puts_options(formulae)
    formulae.each do |f|
      next if f.options.empty?
      if ARGV.include? "--compact"
        puts f.options.as_flags.sort * " "
      else
        puts f.full_name if formulae.length > 1
        dump_options_for_formula f
        puts
      end
    end
  end
end
