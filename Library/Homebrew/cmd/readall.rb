# `brew readall` tries to import all formulae one-by-one.
# This can be useful for debugging issues across all formulae
# when making significant changes to formula.rb,
# or to determine if any current formulae have Ruby issues

require 'formula'
require 'cmd/tap'
require 'thread'

module Homebrew
  def readall
    if ARGV.delete("--syntax")
      ruby_files = Queue.new
      Dir.glob("#{HOMEBREW_LIBRARY}/Homebrew/**/*.rb").each do |rb|
        ruby_files << rb
      end

      failed = false
      workers = (0...Hardware::CPU.cores).map do
        Thread.new do
          begin
            while rb = ruby_files.pop(true)
              nostdout { failed = true unless system "ruby", "-c", "-w", rb }
            end
          rescue ThreadError # ignore empty queue error
          end
        end
      end
      workers.map(&:join)
      Homebrew.failed = failed
    end

    formulae = []
    if ARGV.named.empty?
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
        onoe "problem in #{Formulary.path(n)}"
        puts e
        Homebrew.failed = true
      end
    end
  end
end
