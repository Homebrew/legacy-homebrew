require 'formula'
require 'formula_versions'

module Homebrew extend self
  def versions
    raise "Please `brew install git` first" unless which "git"
    raise "Please `brew update' first" unless (HOMEBREW_REPOSITORY/".git").directory?

    raise FormulaUnspecifiedError if ARGV.named.empty?

    ARGV.formulae.all? do |f|
      if ARGV.include? '--compact'
        puts f.versions * " "
      else
        f.versions do |version, sha|
          print Tty.white.to_s
          print "#{version.ljust(8)} "
          print Tty.reset.to_s
          puts "git checkout #{sha} #{f.pretty_relative_path}"
        end
      end
    end
  end
end
