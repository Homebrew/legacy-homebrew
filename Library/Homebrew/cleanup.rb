require "bottles"
require "formula"
require "thread"

module Homebrew
  module Cleanup
    @@disk_cleanup_size = 0

    def self.cleanup
      cleanup_cellar
      cleanup_cache
      cleanup_logs
      unless ARGV.dry_run?
        cleanup_lockfiles
        rm_DS_Store
      end
    end

    def self.update_disk_cleanup_size(path_size)
      @@disk_cleanup_size += path_size
    end

    def self.disk_cleanup_size
      @@disk_cleanup_size
    end

    def self.cleanup_formula(formula)
      formula.eligible_kegs_for_cleanup.each do |keg|
        cleanup_path(keg) { keg.uninstall }
      end
    end

    def self.cleanup_logs
      return unless HOMEBREW_LOGS.directory?
      HOMEBREW_LOGS.subdirs.each do |dir|
        cleanup_path(dir) { dir.rmtree } if prune?(dir, :days_default => 14)
      end
    end

    def self.cleanup_cellar
      Formula.installed.each do |formula|
        cleanup_formula formula
      end
    end

    def self.cleanup_cache
      return unless HOMEBREW_CACHE.directory?
      HOMEBREW_CACHE.children.each do |path|
        if path.to_s.end_with? ".incomplete"
          cleanup_path(path) { path.unlink }
          next
        end
        if path.basename.to_s == "java_cache" && path.directory?
          cleanup_path(path) { FileUtils.rm_rf path }
          next
        end
        if prune?(path)
          if path.file?
            cleanup_path(path) { path.unlink }
          elsif path.directory? && path.to_s.include?("--")
            cleanup_path(path) { FileUtils.rm_rf path }
          end
          next
        end

        next unless path.file?
        file = path

        if Pathname::BOTTLE_EXTNAME_RX === file.to_s
          version = bottle_resolve_version(file) rescue file.version
        else
          version = file.version
        end
        next unless version
        next unless (name = file.basename.to_s[/(.*)-(?:#{Regexp.escape(version)})/, 1])

        next unless HOMEBREW_CELLAR.directory?

        begin
          f = Formulary.from_rack(HOMEBREW_CELLAR/name)
        rescue FormulaUnavailableError, TapFormulaAmbiguityError, TapFormulaWithOldnameAmbiguityError
          next
        end

        file_is_stale = if PkgVersion === version
          f.pkg_version > version
        else
          f.version > version
        end

        if file_is_stale || ARGV.switch?("s") && !f.installed? || bottle_file_outdated?(f, file)
          cleanup_path(file) { file.unlink }
        end
      end
    end

    def self.cleanup_path(path)
      if ARGV.dry_run?
        puts "Would remove: #{path} (#{path.abv})"
      else
        puts "Removing: #{path}... (#{path.abv})"
        yield
      end

      update_disk_cleanup_size(path.disk_usage)
    end

    def self.cleanup_lockfiles
      return unless HOMEBREW_CACHE_FORMULA.directory?
      candidates = HOMEBREW_CACHE_FORMULA.children
      lockfiles  = candidates.select { |f| f.file? && f.extname == ".brewing" }
      lockfiles.each do |file|
        next unless file.readable?
        file.open.flock(File::LOCK_EX | File::LOCK_NB) && file.unlink
      end
    end

    def self.rm_DS_Store
      paths = Queue.new
      %w[Cellar Frameworks Library bin etc include lib opt sbin share var].
        map { |p| HOMEBREW_PREFIX/p }.each { |p| paths << p if p.exist? }
      workers = (0...Hardware::CPU.cores).map do
        Thread.new do
          begin
            while p = paths.pop(true)
              quiet_system "find", p, "-name", ".DS_Store", "-delete"
            end
          rescue ThreadError # ignore empty queue error
          end
        end
      end
      workers.map(&:join)
    end

    def self.prune?(path, options = {})
      @time ||= Time.now

      path_modified_time = path.mtime
      days_default = options[:days_default]

      prune = ARGV.value "prune"

      return true if prune == "all"

      prune_time = if prune
        @time - 60 * 60 * 24 * prune.to_i
      elsif days_default
        @time - 60 * 60 * 24 * days_default.to_i
      end

      return false unless prune_time

      path_modified_time < prune_time
    end
  end
end
