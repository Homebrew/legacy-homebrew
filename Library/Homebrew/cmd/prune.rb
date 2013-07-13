require 'keg'
require 'cmd/tap'

module Homebrew extend self
  # $n and $d are used by the ObserverPathnameExtension to keep track of
  # certain filesystem actions.

  def prune
    $n = 0
    $d = 0
    dirs = []

    Keg::PRUNEABLE_DIRECTORIES.select(&:directory?).each do |dir|
      dir.find do |path|
        path.extend(ObserverPathnameExtension)
        if path.symlink?
          # path.resolved_path_exists? may throw exception -- if so, consider that path does not exist
          path_exists = false
          begin
            path_exists = path.resolved_path_exists?
          rescue
            # if that threw an exception, path_exists is still false
          end
          unless path_exists
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

    if $n == 0 && $d == 0
      puts "Nothing pruned" if ARGV.verbose?
    else
      print "Pruned #{$n} symbolic links "
      print "and #{$d} directories " if $d > 0
      puts  "from #{HOMEBREW_PREFIX}"
    end unless ARGV.dry_run?
  end
end
