require 'formula'

module Homebrew
  def options
    if ARGV.include? '--all'
      puts_options Formula.to_a
    elsif ARGV.include? '--installed'
      puts_options Formula.installed
    else
      raise FormulaUnspecifiedError if ARGV.named.empty?
      puts_options ARGV.formulae
    end
  end

  def puts_options(formulae)
    formulae.each do |f|
      next if f.build.empty?
      if ARGV.include? '--compact'
        puts f.build.as_flags.sort * " "
      else
        puts f.name if formulae.length > 1
        dump_options_for_formula f
        puts
      end
    end
  end

  def dump_options_for_formula f
    f.build.sort_by(&:flag).each do |opt|
      puts opt.flag
      puts "\t"+opt.description
    end
    if f.devel
      puts '--devel'
      puts "\tinstall development version #{f.devel.version}"
    end
    if f.head
      puts '--HEAD'
      puts "\tinstall HEAD version"
    end
  end
end
