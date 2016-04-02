require "formula"
require "keg"
require "formula_printer"

module Homebrew
  def outdated
    OutdatedFormulaePrinter.print
  end

  class OutdatedFormulaePrinter < FormulaPrinter
    def selection
      @domain.select(&:outdated?)
    end

    def print_verbose
      @selection.each do |f|
        puts "#{f.full_name} (#{f.outdated_versions*", "} < #{f.pkg_version})"
      end
    end

    def json
      @selection.map do |f|
        { :name => f.full_name,
          :installed_versions => f.outdated_versions.collect(&:to_s),
          :current_version => f.pkg_version.to_s }
      end
    end
  end
end
