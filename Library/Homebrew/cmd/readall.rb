# `brew readall` tries to import all formulae one-by-one.
# This can be useful for debugging issues across all formulae
# when making significant changes to formula.rb,
# or to determine if any current formulae have Ruby issues

require "formula"
require "cmd/tap"
require "thread"

module Homebrew
  def readall
    if ARGV.delete("--syntax")
      ruby_files = Queue.new
      Dir.glob("#{HOMEBREW_LIBRARY}/Homebrew/**/*.rb").each do |rb|
        next if rb.include?("/vendor/")
        ruby_files << rb
      end

      failed = false
      workers = (0...Hardware::CPU.cores).map do
        Thread.new do
          begin
            while rb = ruby_files.pop(true)
              nostdout { failed = true unless system RUBY_PATH, "-c", "-w", rb }
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
      formulae = Formula.files
    else
      tap = Tap.new(*tap_args)
      raise TapUnavailableError, tap.name unless tap.installed?
      formulae = tap.formula_files
    end

    formulae.each do |file|
      begin
        Formulary.factory(file)
      rescue Exception => e
        onoe "problem in #{file}"
        puts e
        Homebrew.failed = true
      end
    end
  end
end
