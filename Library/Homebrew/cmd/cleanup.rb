require "formula"
require "keg"
require "bottles"

module Homebrew
  def cleanup
    if ARGV.named.empty?
      cleanup_cellar
      cleanup_cache
      cleanup_logs
      unless ARGV.dry_run?
        cleanup_lockfiles
        rm_DS_Store
      end
    else
      ARGV.resolved_formulae.each { |f| cleanup_formula(f) }
    end
  end

  def cleanup_logs
    return unless HOMEBREW_LOGS.directory?
    HOMEBREW_LOGS.subdirs.each do |dir|
      cleanup_path(dir) { dir.rmtree } if prune?(:logs, dir.mtime)
    end
  end

  def cleanup_cellar
    Formula.installed.each do |formula|
      cleanup_formula formula
    end
  end

  def cleanup_formula(f)
    if f.installed?
      eligible_kegs = f.rack.subdirs.map { |d| Keg.new(d) }.select { |k| f.pkg_version > k.version }
      if eligible_kegs.any? && eligible_for_cleanup?(f)
        eligible_kegs.each { |keg| cleanup_keg(keg) }
      else
        eligible_kegs.each { |keg| opoo "Skipping (old) keg-only: #{keg}" }
      end
    elsif f.rack.subdirs.length > 1
      # If the cellar only has one version installed, don't complain
      # that we can't tell which one to keep.
      opoo "Skipping #{f.full_name}: most recent version #{f.pkg_version} not installed"
    end
  end

  def cleanup_keg(keg)
    if keg.linked?
      opoo "Skipping (old) #{keg} due to it being linked"
    else
      cleanup_path(keg) { keg.uninstall }
    end
  end

  def cleanup_cache
    return unless HOMEBREW_CACHE.directory?
    HOMEBREW_CACHE.children.each do |path|
      if prune?(:cache, path.mtime)
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
      rescue FormulaUnavailableError, TapFormulaAmbiguityError
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

  def cleanup_path(path)
    if ARGV.dry_run?
      puts "Would remove: #{path} (#{path.abv})"
    else
      puts "Removing: #{path}... (#{path.abv})"
      yield
    end
  end

  def cleanup_lockfiles
    return unless HOMEBREW_CACHE_FORMULA.directory?
    candidates = HOMEBREW_CACHE_FORMULA.children
    lockfiles  = candidates.select { |f| f.file? && f.extname == ".brewing" }
    lockfiles.select(&:readable?).each do |file|
      file.open.flock(File::LOCK_EX | File::LOCK_NB) && file.unlink
    end
  end

  def rm_DS_Store
    paths = %w[Cellar Frameworks Library bin etc include lib opt sbin share var].
            map { |p| HOMEBREW_PREFIX/p }.select(&:exist?)
    args = paths.map(&:to_s) + %w[-name .DS_Store -delete]
    quiet_system "find", *args
  end

  def prune?(kind, time)
    unless @cleanup_prune_limit
      # Infer and cache prune limits for cleanup: Use '--prune' or fall back to
      # defaults (never prune download cache and prune logs after two weeks).
      days = ARGV.value "prune"
      offset = Time.now
      @cleanup_prune_limit = {}
      { :cache => nil, :logs => 14 }.each do |k, days_default|
        @cleanup_prune_limit[k] = if days == "all"
          "all"
        elsif days
          offset - 60 * 60 * 24 * days.to_i
        elsif days_default
          offset - 60 * 60 * 24 * days_default
        end
      end
    end

    if limit = @cleanup_prune_limit[kind]
      limit == "all" || time < limit
    end
  end

  def eligible_for_cleanup?(formula)
    # It used to be the case that keg-only kegs could not be cleaned up, because
    # older brews were built against the full path to the keg-only keg. Then we
    # introduced the opt symlink, and built against that instead. So provided
    # no brew exists that was built against an old-style keg-only keg, we can
    # remove it.
    if !formula.keg_only? || ARGV.force?
      true
    elsif formula.opt_prefix.directory?
      # SHA records were added to INSTALL_RECEIPTS the same day as opt symlinks
      Formula.installed.select do |f|
        f.deps.any? do |d|
          d.to_formula.full_name == formula.full_name rescue d.name == formula.name
        end
      end.all? { |f| f.rack.subdirs.all? { |keg| Tab.for_keg(keg).HEAD } }
    end
  end
end
