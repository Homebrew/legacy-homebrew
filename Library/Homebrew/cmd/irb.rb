module Homebrew extend self
  def irb
    if ARGV.include? "--help"
      puts "Formula.factory('ace').installed?"
    else
      ohai "Interactive Homebrew Shell"
      puts "Example commands available with: brew irb --help"
      require 'formula'
      require 'keg'
      require 'irb'
      IRB.start
    end
  end
end
