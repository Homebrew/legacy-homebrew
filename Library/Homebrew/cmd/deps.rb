module Homebrew extend self
  def deps
    puts if ARGV.include?('--all')
      require 'formula'
      Formula.all.each do |f|
        "#{f.name}:#{f.deps.join(' ')}"
      end
    elsif ARGV.include?("-1") or ARGV.include?("--1")
      *ARGV.formulae.map{ |f| f.deps or [] }.flatten.uniq.sort
    else
      *ARGV.formulae.map{ |f| f.recursive_deps.map{ |f| f.name } }.flatten.uniq.sort
    end
  end
end
