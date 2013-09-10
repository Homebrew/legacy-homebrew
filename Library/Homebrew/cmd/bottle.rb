require 'formula'
require 'bottles'
require 'tab'
require 'keg'

class BottleMerger < Formula
  # This provides a URL and Version which are the only needed properties of
  # a Formula. This object is used to access the Formula bottle DSL to merge
  # multiple outputs of `brew bottle`.
  url '1'
end

module Homebrew extend self
  def keg_contains string, keg
    quiet_system 'fgrep', '--recursive', '--quiet', '--max-count=1', string, keg
  end

  def bottle_output bottle
    puts "bottle do"
    prefix = bottle.prefix.to_s
    puts "  prefix '#{prefix}'" if prefix != '/usr/local'
    cellar = if bottle.cellar.is_a? Symbol
      ":#{bottle.cellar}"
    elsif bottle.cellar.to_s != '/usr/local/Cellar'
      "'bottle.cellar'"
    end
    puts "  cellar #{cellar}" if cellar
    puts "  revision #{bottle.revision}" if bottle.revision > 0
    Checksum::TYPES.each do |checksum_type|
      checksum_os_versions = bottle.send checksum_type
      next unless checksum_os_versions
      os_versions = checksum_os_versions.keys
      os_versions.map! {|osx| MacOS::Version.from_symbol osx }
      os_versions.sort.reverse.each do |os_version|
        osx = os_version.to_sym
        checksum = checksum_os_versions[osx]
        puts "  #{checksum_type} '#{checksum}' => :#{osx}"
      end
    end
    puts "end"
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

    if bottle_filename_formula_name(filename).empty?
      return ofail "Add a new regex to bottle_version.rb to parse the bottle filename."
    end

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

        if prefix == '/usr/local'
          prefix_check = HOMEBREW_PREFIX/'opt'
        else
          prefix_check = HOMEBREW_PREFIX
        end

        relocatable = !keg_contains(prefix_check, keg)
        relocatable = !keg_contains(HOMEBREW_CELLAR, keg) if relocatable

        # And do the same thing in reverse to change the library references
        # back to how they were.
        keg.relocate_install_names tmp_prefix, prefix, tmp_cellar, cellar
      end

      bottle = Bottle.new
      bottle.prefix HOMEBREW_PREFIX
      bottle.cellar relocatable ? :any : HOMEBREW_CELLAR
      bottle.revision bottle_revision
      bottle.sha1 sha1 => bottle_tag

      puts "./#{filename}"
      bottle_output bottle
    end
  end

  def bottle
    if ARGV.include? '--merge'
      ARGV.named.each do |argument|
        bottle_block = IO.read(argument)
        BottleMerger.class_eval bottle_block
      end
      bottle = BottleMerger.new.bottle
      bottle_output bottle if bottle
      exit 0
    end

    ARGV.formulae.each do |f|
      bottle_formula f
    end
  end
end
