require 'formula'
require 'keg'
require 'bottles'
require 'cmd/prune'

module Homebrew extend self

  def cleanup
    if ARGV.named.empty?
      HOMEBREW_CELLAR.children.each do |rack|
        begin
          cleanup_formula rack.basename.to_s if rack.directory?
        rescue FormulaUnavailableError => e
          # Don't complain about Cellar folders that are from DIY installs
          # instead of core formulae.
        end
      end
      clean_cache
      # seems like a good time to do some additional cleanup
      Homebrew.prune unless ARGV.dry_run?
      rm_DS_Store
    else
      ARGV.formulae.each do |f|
        cleanup_formula f
      end
    end
  end

  def cleanup_formula f
    f = Formula.factory f

    if f.installed? and f.rack.directory?
      f.rack.children.each do |keg|
        if f.installed_prefix != keg
          if f.can_cleanup?
            puts "Removing #{keg}..."
            rm_rf keg unless ARGV.dry_run?
          else
            opoo "Skipping (old) keg-only: #{keg}"
          end
        end
      end
    elsif f.rack.children.length > 1
      # If the cellar only has one version installed, don't complain
      # that we can't tell which one to keep.
      opoo "Skipping #{f.name}: most recent version #{f.version} not installed"
    end
  end

  def clean_cache
    HOMEBREW_CACHE.children.each do |pn|
      next unless pn.file?
      version = pn.version
      name = pn.basename.to_s.match(/(.*)-(#{version})/).captures.first rescue nil
      if name and version
        f = Formula.factory(name) rescue nil
        old_bottle = bottle_file_outdated? f, pn
        if not f or (f.version != version or ARGV.switch? "s" and not f.installed?) or old_bottle
          puts "Removing #{pn}..."
          rm pn unless ARGV.dry_run?
        end
      end
    end
  end

  def rm_DS_Store
    system "find #{HOMEBREW_PREFIX} -name .DS_Store -delete"
  end

end

class Formula
  def can_cleanup?
    # It used to be the case that keg-only kegs could not be cleaned up, because
    # older brews were built against the full path to the keg-only keg. Then we
    # introduced the opt symlink, and built against that instead. So provided
    # no brew exists that was built against an old-style keg-only keg, we can
    # remove it.
    if not keg_only?
      true
    elsif opt_prefix.directory?
      # SHA records were added to INSTALL_RECEIPTS the same day as opt symlinks
      !Formula.installed.
        select{ |ff| ff.deps.map(&:to_s).include? name }.
        map{ |ff| ff.rack.children rescue [] }.
        flatten.
        map{ |keg_path| Tab.for_keg(keg_path).sha }.
        include? nil
    end
  end
end
