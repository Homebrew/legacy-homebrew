# `brew readall` tries to import all formulae one-by-one.
# This can be useful for debugging issues across all formulae
# when making significant changes to formula.rb,
# or to determine if any current formulae have Ruby issues

require "formula"
require "tap"
require "core_formula_repository"
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
      nostdout do
        workers = (0...Hardware::CPU.cores).map do
          Thread.new do
            begin
              while rb = ruby_files.pop(true)
                failed = true unless system RUBY_PATH, "-c", "-w", rb
              end
            rescue ThreadError # ignore empty queue error
            end
          end
        end
        workers.map(&:join)
      end
      Homebrew.failed = failed
    end

    formulae = []
    alias_dirs = []
    if ARGV.named.empty?
      formulae = Formula.files
      alias_dirs = Tap.map(&:alias_dir)
    else
      tap = Tap.fetch(ARGV.named.first)
      raise TapUnavailableError, tap.name unless tap.installed?
      formulae = tap.formula_files
      alias_dirs = [tap.alias_dir]
    end

    if ARGV.delete("--aliases")
      alias_dirs.each do |alias_dir|
        next unless alias_dir.directory?
        Pathname.glob("#{alias_dir}/*").each do |f|
          next unless f.symlink?
          next if f.file?
          onoe "Broken alias: #{f}"
          Homebrew.failed = true
        end
      end
    end

    formulae.each do |file|
      begin
        Formulary.factory(file)
      rescue Interrupt
        raise
      rescue Exception => e
        onoe "problem in #{file}"
        puts e
        Homebrew.failed = true
      end
    end
  end
end
