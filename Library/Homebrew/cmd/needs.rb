require "formula"

module Homebrew
  def needs
    if ARGV.named.empty?
      puts "Usage: brew needs <formula>"
    else
      ARGV.named.each do |f|
        print_needs f
      end
    end
  end

  def print_needs(f_in, indent="")
    installed = Formula.installed
    # For each installed formula f, check for formula f_in's dependencies
    installed.each do |f|
      f.deps.each do |dep|
        begin
          if dep.to_formula == Formula.factory(f_in)
            # if found, print and recursion
            if dep.optional?
              puts indent + f.full_name + " (#{f_in} optional)"
              print_needs(f.full_name, indent + "  ")
            elsif dep.recommended?
              puts indent + f.full_name + " (#{f_in} recommended)"
              print_needs(f.full_name, indent + "  ")
            else
              puts indent + f.full_name
              print_needs(f.full_name, indent + "  ")
            end
          end
        rescue FormulaUnavailableError
          # This may happen...
        end
      end
    end

  end
end
