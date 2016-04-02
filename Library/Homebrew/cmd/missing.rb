require "formula"
require "diagnostic"
require "formula_printer"

module Homebrew
  def missing
    MissingFormulaePrinter.print
  end

  class MissingFormulaePrinter < FormulaPrinter
    def selection
      Diagnostic.missing_deps(@domain)
    end

    def print_verbose
      @selection.each do |formula_name, missing_deps|
        print "#{formula_name}: " if @domain.size > 1
        puts (missing_deps.map(&:full_name) * " ").to_s
      end
    end

    def json
      @selection.map do |formula_name, missing_deps|
        { :name => formula_name, :missing => missing_deps.map(&:full_name) }
      end
    end
  end
end
