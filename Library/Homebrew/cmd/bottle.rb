require 'formula'
require 'tab'

module Homebrew extend self
  def formula_bottle_name f
    "#{f.name}-#{f.version}.#{MacOS.cat}.bottle.tar.gz"
  end

  def bottle_formula f
    return onoe "Formula not installed: #{f.name}" unless f.installed?
    return onoe "Formula not installed with '--build-bottle': #{f.name}" unless Tab.for_formula(f).built_bottle

    directory = Pathname.pwd
    filename = formula_bottle_name f

    HOMEBREW_CELLAR.cd do
      ohai "Bottling #{f.name} #{f.version}..."
      # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
      # or an uncompressed tarball (and more bandwidth friendly).
      safe_system 'tar', 'czf', directory/filename, "#{f.name}/#{f.version}"
      puts "./#{filename}"
      puts "bottle do"
      puts "  url 'https://downloads.sf.net/project/machomebrew/Bottles/#{filename}'"
      puts "  sha1 '#{(directory/filename).sha1}'"
      puts "end"
    end
  end

  def bottle
    ARGV.formulae.each do|f|
      bottle_formula Formula.factory f
    end
  end
end
