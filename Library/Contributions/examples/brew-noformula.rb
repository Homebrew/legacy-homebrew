require "formula"
require "cmd/outdated"

def check_kegs names
    kegs_to_check = []
    missing_kegs = []

    subdirs = HOMEBREW_CELLAR.subdirs.map{ |rack| rack.basename.to_s }

    if names.empty?
      kegs_to_check = subdirs
    else
      names.each do |name|
        if subdirs.include?(name)
          kegs_to_check << name
        else
          missing_kegs << name
        end
      end
    end

    unless missing_kegs.empty?
      raise "No such kegs: #{missing_kegs * ', '}"
    end

    kegs_to_check
end

def missing_formulae names
  kegs = []
  HOMEBREW_CELLAR.subdirs.collect do |rack|
    name = rack.basename.to_s
    next unless names.include?(name)

    begin
      Formula.factory(name)
      nil
    rescue => e
      kegs << rack.basename.to_s
    end
  end
  kegs
end

def main
  return unless HOMEBREW_CELLAR.exist?

  kegs_to_check = check_kegs ARGV.named

  missing_formulae = missing_formulae(kegs_to_check)

  unless missing_formulae.empty?
    missing_formulae.each do |keg|
      puts "#{keg}"
    end
  end
end

main()
