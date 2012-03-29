require 'formula'
require 'bottles'
require 'tab'

module Homebrew extend self
  def bottle_formula f
    unless f.installed?
      onoe "Formula not installed: #{f.name}"
      Homebrew.failed = true
      return
    end

    unless built_bottle? f
      onoe "Formula not installed with '--build-bottle': #{f.name}"
      Homebrew.failed = true
    end

    directory = Pathname.pwd
    filename = bottle_filename f

    HOMEBREW_CELLAR.cd do
      ohai "Bottling #{f.name} #{f.version}..."
      # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
      # or an uncompressed tarball (and more bandwidth friendly).
      safe_system 'tar', 'czf', directory/filename, "#{f.name}/#{f.version}"
      puts "./#{filename}"
      puts "bottle do"
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
