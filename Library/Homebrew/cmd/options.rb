require 'formula'
require 'cmd/outdated'

def ff
  if ARGV.include? "--all"
    Formula.all
  elsif ARGV.include? "--installed"
    # outdated brews count as installed
    outdated = Homebrew.outdated_brews.collect{ |b| b.name }
    Formula.all.select do |f|
      f.installed? or outdated.include? f.name
    end
  else
    raise FormulaUnspecifiedError if ARGV.named.empty?
    ARGV.formulae
  end
end

module Homebrew extend self
  def options
    ff.each do |f|
      next if f.options.empty?
      if ARGV.include? '--compact'
        puts f.options.collect {|o| o[0]} * " "
      else
        puts f.name if ff.length > 1
        dump_options_for_formula f
        puts
      end
    end
  end

  def dump_options_for_formula f
    f.options.each do |o|
      puts o[0]
      puts "\t"+o[1]
    end
  end
end
