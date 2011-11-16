require 'formula'

def ff
  if ARGV.include? "--all"
    Formula.all
  elsif ARGV.include? "--installed"
    Formula.all.reject{ |f| not f.installed? }
  else
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
        puts "#{Tty.white}#{f.name}#{Tty.reset}"
        f.options.each do |k,v|
          puts k
          puts "\t"+v
        end
        puts
      end
    end
  end
end