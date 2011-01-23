require 'formula'

module Homebrew extend self
  def deps
    if ARGV.include? '--all'
      Formula.each do |f|
        # TODO add a space after the colon??
        puts "#{f.name}:#{f.deps*' '}"
      end
    else
      func = if ARGV.one? then :deps else :recursive_deps end
      puts ARGV.formulae.map(&func).intersection.sort
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
