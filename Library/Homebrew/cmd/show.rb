module Homebrew extend self
  def show
    require 'formula'
    cd HOMEBREW_REPOSITORY
    formulae = ARGV.formulae
    revs = ARGV.named - formulae.map(&:name)
    revs = %w{HEAD} if formulae.empty? && revs.empty?
    formulae.each do |f|
      system 'git', 'log', '-1', '-p', *(ARGV.options_only + ['--', f.path])
    end
    revs.each do |r|
      system 'git', 'show', *ARGV.options_only << r
    end
  end
end
