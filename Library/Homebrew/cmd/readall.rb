# `brew readall` tries to import all formulae one-by-one.
# This can be useful for debugging issues across all formulae
# when making significant changes to formula.rb,
# or to determine if any current formulae have Ruby issues

require 'formula'
require 'cmd/tap'

module Homebrew
  def readall
    formulae = []
    if ARGV.empty?
      formulae = Formula.names
    else
      user, repo = tap_args
      user.downcase!
      repo.downcase!
      tap = HOMEBREW_LIBRARY/"Taps/#{user}/homebrew-#{repo}"
      raise "#{tap} does not exist!" unless tap.directory?
      tap.find_formula { |f| formulae << f }
    end

    formulae.sort.each do |n|
      begin
        Formulary.factory(n)
      rescue Exception => e
        onoe "problem in #{Formula.path(n)}"
        puts e
        Homebrew.failed = true
      end
    end
  end
end
