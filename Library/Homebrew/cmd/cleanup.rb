require 'formula'
require 'keg'
require 'bottles'
require 'cmd/prune'

module Homebrew extend self

  def cleanup
    if ARGV.named.empty?
      if HOMEBREW_CELLAR.directory?
        HOMEBREW_CELLAR.children.each do |rack|
          begin
            cleanup_formula rack.basename.to_s if rack.directory?
          rescue FormulaUnavailableError
            # Don't complain about Cellar folders that are from DIY installs
            # instead of core formulae.
          end
        end
      end
      clean_cache
      # seems like a good time to do some additional cleanup
      unless ARGV.dry_run?
        Homebrew.prune
        rm_DS_Store
      end
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
        if File.directory? keg and f.version > Keg.new(keg).version
          if f.can_cleanup?
            if !Keg.new(keg).linked?
              if ARGV.dry_run?
                puts "Would remove: #{keg}"
              else
                puts "Removing: #{keg}..."
                rm_rf keg
              end
            else
              opoo "Skipping (old) #{keg} due to it being linked"
            end
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
    return unless HOMEBREW_CACHE.directory?
    HOMEBREW_CACHE.children.each do |pn|
      next unless pn.file?
      version = pn.version
      name = pn.basename.to_s.match(/(.*)-(#{version})/).captures.first rescue nil
      if name and version
        f = Formula.factory(name) rescue nil
        old_bottle = bottle_file_outdated? f, pn
        if (f and f.version > version) or (ARGV.switch? "s" and (f and (not f.installed?))) or old_bottle
          if ARGV.dry_run?
            puts "Would remove: #{pn}"
          else
            puts "Removing: #{pn}..."
            rm pn
          end
        end
      end
    end
  end

  def rm_DS_Store
    system "find #{HOMEBREW_PREFIX} -name .DS_Store -delete 2>/dev/null"
  end

end

class Formula
  def can_cleanup?
    # It used to be the case that keg-only kegs could not be cleaned up, because
    # older brews were built against the full path to the keg-only keg. Then we
    # introduced the opt symlink, and built against that instead. So provided
    # no brew exists that was built against an old-style keg-only keg, we can
    # remove it.
    if not keg_only? or ARGV.force?
      true
    elsif opt_prefix.directory?
      # SHA records were added to INSTALL_RECEIPTS the same day as opt symlinks
      !Formula.installed.
        select{ |ff| ff.deps.map{ |d| d.to_s }.include? name }.
        map{ |ff| ff.rack.children rescue [] }.
        flatten.
        map{ |keg_path| Tab.for_keg(keg_path).send("HEAD") }.
        include? nil
    end
  end
end
