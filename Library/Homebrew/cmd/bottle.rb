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

    bottle_revision = bottle_new_revision f
    filename = bottle_filename f, bottle_revision
    bottle_path = Pathname.pwd/filename
    sha1 = nil

    HOMEBREW_CELLAR.cd do
      ohai "Bottling #{f.name} #{f.version}..."
      bottle_relocatable = !quiet_system(
        'grep', '--recursive', '--quiet', '--max-count=1',
                HOMEBREW_CELLAR, "#{f.name}/#{f.version}")
      cellar = nil
      if bottle_relocatable
        cellar = ':any'
      elsif HOMEBREW_CELLAR.to_s != '/usr/local/Cellar'
        cellar = "'#{HOMEBREW_CELLAR}'"
      end
      # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
      # or an uncompressed tarball (and more bandwidth friendly).
      safe_system 'tar', 'czf', bottle_path, "#{f.name}/#{f.version}"
      sha1 = bottle_path.sha1
      puts "./#{filename}"
      puts "bottle do"
      puts "  cellar #{cellar}" if cellar
      puts "  revision #{bottle_revision}" if bottle_revision > 0
      puts "  sha1 '#{sha1}' => :#{MacOS.cat}"
      puts "end"
    end
  end

  def bottle
    ARGV.formulae.each do|f|
      bottle_formula Formula.factory f
    end
  end
end
