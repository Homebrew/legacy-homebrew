require 'formula'

module Homebrew extend self
  def deps
    if ARGV.include? '--all'
      Formula.each do |f|
        ohai "#{f.name}:"
        puts "  #{f.deps*' '}"
        puts
      end
      
    elsif ARGV.include? '--installed'
      Formula.each do |f|
        if f.installed?
          unless f.deps.empty?
            ohai "#{f.name}"
            puts "  #{f.deps*' '}"
            puts
          end
        end
      end

    else
      all_deps = ARGV.formulae.map{ |f| ARGV.one? ? f.deps : f.recursive_deps }.intersection
      all_deps.sort! unless ARGV.include? "-n"
      puts all_deps
    end
  end
end

class Array
  def intersection
    a = []
    each{ |b| a |= b }
    each{ |c| a &= c }
    a
  end
end
