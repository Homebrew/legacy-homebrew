require "formula"
require "keg"
require "cmd/link"

module Homebrew
  def switch
    if ARGV.named.length != 2
      onoe "Usage: brew switch <name> <version>"
      exit 1
    end

    name = ARGV.shift
    version = ARGV.shift

    rack = Formulary.to_rack(name)

    unless rack.directory?
      onoe "#{name} not found in the Cellar."
      exit 2
    end

    # Does the target version exist?
    unless (rack+version).directory?
      onoe "#{name} does not have a version \"#{version}\" in the Cellar."

      versions = rack.subdirs.map { |d| Keg.new(d).version }
      puts "Versions available: #{versions.join(", ")}"

      exit 3
    end

    # Unlink all existing versions
    rack.subdirs.each do |v|
      keg = Keg.new(v)
      puts "Cleaning #{keg}"
      keg.unlink
    end

    keg = Keg.new(rack+version)

    # Link new version, if not keg-only
    if keg_only?(rack)
      keg.optlink
      puts "Opt link created for #{keg}"
    else
      puts "#{keg.link} links created for #{keg}"
    end
  end
end
