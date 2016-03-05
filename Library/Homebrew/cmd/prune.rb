require "keg"
require "cmd/tap"

module Homebrew
  def prune
    ObserverPathnameExtension.reset_counts!

    dirs = []

    Keg::PRUNEABLE_DIRECTORIES.each do |dir|
      next unless dir.directory?
      dir.find do |path|
        path.extend(ObserverPathnameExtension)
        if path.symlink?
          unless path.resolved_path_exists?
            if path.to_s =~ Keg::INFOFILE_RX
              path.uninstall_info unless ARGV.dry_run?
            end

            if ARGV.dry_run?
              puts "Would remove (broken link): #{path}"
            else
              path.unlink
            end
          end
        elsif path.directory?
          dirs << path
        end
      end
    end

    dirs.reverse_each do |d|
      if ARGV.dry_run? && d.children.empty?
        puts "Would remove (empty directory): #{d}"
      else
        d.rmdir_if_possible
      end
    end

    if ObserverPathnameExtension.total.zero?
      puts "Nothing pruned" if ARGV.verbose?
    else
      n, d = ObserverPathnameExtension.counts
      print "Pruned #{n} symbolic links "
      print "and #{d} directories " if d > 0
      puts "from #{HOMEBREW_PREFIX}"
    end unless ARGV.dry_run?
  end
end
