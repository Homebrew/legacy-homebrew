require 'formula'

module Homebrew extend self
  def deps
    if ARGV.include? '--all'
      Formula.each do |f|
        # TODO add a space after the colon??
        puts "#{f.name}:#{f.deps*' '}"
      end
    else
      puts ARGV.formulae.map{ |f| ARGV.one? ? f.deps : f.recursive_deps }.intersection.sort
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
