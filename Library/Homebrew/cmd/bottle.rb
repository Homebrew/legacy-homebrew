require 'formula'
require 'bottles'
require 'tab'

module Homebrew extend self
  def bottle_formula f
    unless f.installed?
      return ofail "Formula not installed: #{f.name}"
      return
    end

    unless built_as_bottle? f
      return ofail "Formula not installed with '--build-bottle': #{f.name}"
    end

    directory = Pathname.pwd
    bottle_version = bottle_new_version f
    filename = bottle_filename f, bottle_version

    HOMEBREW_CELLAR.cd do
      ohai "Bottling #{f.name} #{f.version}..."
      # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
      # or an uncompressed tarball (and more bandwidth friendly).
      safe_system 'tar', 'czf', directory/filename, "#{f.name}/#{f.version}"
      puts "./#{filename}"
      puts "bottle do"
      puts "  version #{bottle_version}" if bottle_version > 0
      puts "  sha1 '#{(directory/filename).sha1}' => :#{MacOS.cat}"
      puts "end"
    end
  end

  def bottle
    ARGV.formulae.each do|f|
      bottle_formula Formula.factory f
    end
  end
end
