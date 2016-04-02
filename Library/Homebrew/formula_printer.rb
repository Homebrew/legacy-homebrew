require "formula"
require "tab"
require "diagnostic"

module Homebrew
  class FormulaPrinter
    attr_reader :domain, :selection

    def initialize
      @domain = domain
      @selection = selection
    end

    def selection
      raise "method missing"
    end

    def domain
      if ARGV.named.empty?
        Formula.installed
      else
        ARGV.resolved_formulae
      end
    end

    def self.print
      return unless HOMEBREW_CELLAR.exist?
      printer = new
      if ARGV.json == "v1"
        printer.print_json
      elsif ($stdout.tty? || ARGV.verbose?) && !ARGV.flag?("--quiet")
        printer.print_verbose
      else
        printer.print_quiet
      end
      printer.exit_status
    end

    def exit_status
      Homebrew.failed = @selection.any?
    end

    def quiet
      @selection.class == Hash ? @selection.values.flatten.uniq : @selection
    end

    def print_quiet
      full_names = quiet.map(&:full_name).sort do |a, b|
        if a.include?("/") && !b.include?("/")
          1
        elsif !a.include?("/") && b.include?("/")
          -1
        else
          a <=> b
        end
      end
      puts_columns full_names
    end

    def print_verbose
      raise "method missing"
    end

    def json
      raise "method missing"
    end

    def print_json
      puts Utils::JSON.dump(json)
    end
  end
end
