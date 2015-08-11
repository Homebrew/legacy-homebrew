require "keg"
require "formula"
require "migrator"

module Homebrew
  def uninstall
    raise KegUnspecifiedError if ARGV.named.empty?

    # Find symlinks that can point to keg.rack
    links = HOMEBREW_CELLAR.subdirs.select(&:symlink?)

    if !ARGV.force?
      ARGV.kegs.each do |keg|
        keg.lock do
          puts "Uninstalling #{keg}... (#{keg.abv})"

          old_cellars = []
          # Remove every symlink that links to keg, because it can
          # be left by migrator
          links.each do |link|
            old_opt = HOMEBREW_PREFIX/"opt/#{link.basename}"
            if link.exist? && link.realpath == keg.rack.realpath
              old_cellars << link
            end

            if old_opt.symlink? && old_opt.realpath.to_s == keg.to_s
              old_opt.unlink
              old_opt.parent.rmdir_if_possible
            end
          end

          keg.unlink
          keg.uninstall
          rack = keg.rack
          rm_pin rack

          if rack.directory?
            versions = rack.subdirs.map(&:basename)
            verb = versions.length == 1 ? "is" : "are"
            puts "#{keg.name} #{versions.join(", ")} #{verb} still installed."
            puts "Remove them all with `brew uninstall --force #{keg.name}`."
          else
            # If we delete Cellar/newname, then Cellar/oldname symlink
            # can become broken and we have to remove it.
            old_cellars.each(&:unlink)
          end
        end
      end
    else
      ARGV.named.each do |name|
        rack = Formulary.to_rack(name)
        name = rack.basename

        links.each do |link|
          old_opt = HOMEBREW_PREFIX/"opt/#{link.basename}"
          if old_opt.symlink? && old_opt.exist? \
              && old_opt.realpath.parent == rack.realpath
            old_opt.unlink
            old_opt.parent.rmdir_if_possible
          end

          link.unlink if link.exist? && link.realpath == rack.realpath
        end

        if rack.directory?
          puts "Uninstalling #{name}... (#{rack.abv})"
          rack.subdirs.each do |d|
            keg = Keg.new(d)
            keg.unlink
            keg.uninstall
          end
        end

        rm_pin rack
      end
    end
  rescue MultipleVersionsInstalledError => e
    ofail e
    puts "Use `brew remove --force #{e.name}` to remove all versions."
  end

  def rm_pin(rack)
    Formulary.from_rack(rack).unpin rescue nil
  end
end
