require 'formula'
require 'keg'
require 'irb'

class String
  def f
    Formula.factory(self)
  end
end

module Homebrew extend self
  def irb
    if ARGV.include? "--help"
      puts "Formula.factory('ace').installed?"
      puts "ack.f # => instance of the Ack formula"
    else
      ohai "Interactive Homebrew Shell"
      puts "Example commands available with: brew irb --help"
      IRB.start
    end
  end
end
