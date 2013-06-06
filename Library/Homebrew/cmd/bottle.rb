require 'formula'
require 'bottles'
require 'tab'
require 'keg'

module Homebrew extend self
  def keg_contains string, keg
    quiet_system 'fgrep', '--recursive', '--quiet', '--max-count=1', string, keg
  end

  def bottle_formula f
    unless f.installed?
      return ofail "Formula not installed: #{f.name}"
    end

    unless built_as_bottle? f
      return ofail "Formula not installed with '--build-bottle': #{f.name}"
    end

    bottle_revision = bottle_new_revision f
    filename = bottle_filename f, bottle_revision
    bottle_path = Pathname.pwd/filename
    sha1 = nil

    prefix = HOMEBREW_PREFIX.to_s
    tmp_prefix = '/tmp'
    cellar = HOMEBREW_CELLAR.to_s
    tmp_cellar = '/tmp/Cellar'

    HOMEBREW_CELLAR.cd do
      ohai "Bottling #{f.name} #{f.version}..."
      # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
      # or an uncompressed tarball (and more bandwidth friendly).
      safe_system 'tar', 'czf', bottle_path, "#{f.name}/#{f.version}"
      sha1 = bottle_path.sha1
      relocatable = false

      keg = Keg.new f.prefix
      keg.lock do
        # Relocate bottle library references before testing for built-in
        # references to the Cellar e.g. Qt's QMake annoyingly does this.
        keg.relocate_install_names prefix, tmp_prefix, cellar, tmp_cellar

        relocatable = !keg_contains(HOMEBREW_PREFIX, keg)
        relocatable = !keg_contains(HOMEBREW_CELLAR, keg) if relocatable

        # And do the same thing in reverse to change the library references
        # back to how they were.
        keg.relocate_install_names tmp_prefix, prefix, tmp_cellar, cellar
      end

      prefix = cellar = nil
      if relocatable
        cellar = ':any'
      else
        if HOMEBREW_PREFIX.to_s != '/usr/local'
          prefix = "'#{HOMEBREW_PREFIX}"
        end
        if HOMEBREW_CELLAR.to_s != '/usr/local/Cellar'
          cellar = "'#{HOMEBREW_CELLAR}'"
        end
      end

      puts "./#{filename}"
      puts "bottle do"
      puts "  prefix #{prefix}" if prefix
      puts "  cellar #{cellar}" if cellar
      puts "  revision #{bottle_revision}" if bottle_revision > 0
      puts "  sha1 '#{sha1}' => :#{bottle_tag}"
      puts "end"
    end
  end

  def bottle
    ARGV.formulae.each do|f|
      bottle_formula Formula.factory f
    end
  end
end
