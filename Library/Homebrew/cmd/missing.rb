require "formula"
require "tab"
require "diagnostic"

module Homebrew
  def missing
    return unless HOMEBREW_CELLAR.exist?

    ff = if ARGV.named.empty?
      Formula.installed
    else
      ARGV.resolved_formulae
    end

    Diagnostic.missing_deps(ff) do |name, missing|
      print "#{name}: " if ff.size > 1
      puts "#{missing * " "}"
    end
  end
end
