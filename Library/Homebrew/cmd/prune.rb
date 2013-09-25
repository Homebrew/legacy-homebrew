require 'keg'
require 'cmd/tap'

module Homebrew extend self
  def prune
    ObserverPathnameExtension.reset_counts!

    dirs = []

    Keg::PRUNEABLE_DIRECTORIES.select(&:directory?).each do |dir|
      dir.find do |path|
        path.extend(ObserverPathnameExtension)
        if path.symlink?
          unless path.resolved_path_exists?
            if ENV['HOMEBREW_KEEP_INFO'] and path.to_s =~ Keg::INFOFILE_RX
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

    dirs.sort.reverse_each do |d|
      if ARGV.dry_run? && d.children.empty?
        puts "Would remove (empty directory): #{d}"
      else
        d.rmdir_if_possible
      end
    end

    repair_taps unless ARGV.dry_run?

    n, d = ObserverPathnameExtension.counts

    if ObserverPathnameExtension.total.zero?
      puts "Nothing pruned" if ARGV.verbose?
    else
      print "Pruned #{n} symbolic links "
      print "and #{d} directories " if d > 0
      puts  "from #{HOMEBREW_PREFIX}"
    end unless ARGV.dry_run?
  end
end
