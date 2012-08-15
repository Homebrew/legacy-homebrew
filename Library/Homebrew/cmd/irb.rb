module Homebrew extend self
  def irb
    if ARGV.include? "--help"
      puts "Formula.factory('ace').installed?"
    else
      ohai "Interactive Homebrew Shell"
      puts "Example commands available with: brew irb --help"
      exec "irb", "-I#{HOMEBREW_REPOSITORY}/Library/Homebrew", "-rglobal", '-rformula', '-rkeg'
    end
  end
end
