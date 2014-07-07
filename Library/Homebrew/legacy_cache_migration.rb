module LegacyCacheMigration
  def mkpath
    migrate! unless exist?
    super
  end

  # Previous versions of Homebrew used a world-writable cache directory in
  # /Library/Caches/Homebrew, or a user-owned cache directory in
  # ~/Library/Caches/Homebrew.  There were security problems with that approach
  # (see https://github.com/mxcl/homebrew/issues/23232) so now we just use a
  # subdirectory of the repository.
  #
  # This migrates the old cache directory to the new location, where it's safe to do so.
  def migrate!
    # Nothing to migrate if the HOMEBREW_CACHE env var is set.
    return if ENV['HOMEBREW_CACHE']

    # Only migrate once, and make sure there's only one process doing the
    # migration.
    if HOMEBREW_CACHE.exist?
      return
    else
      HOMEBREW_CACHE.dirname.mkpath
      begin
        HOMEBREW_CACHE.mkdir
      rescue Errno::EEXIST
        # Some other process created the directory.  Don't migrate.
        return
      end
    end

    # Previous versions of homebrew used ~/Library/Caches/Homebrew as a cache
    # if it existed.  Attempt to migrate this to the new cache dir.
    home_cache = Pathname.new("~/Library/Caches/Homebrew").expand_path
    if home_cache.directory? and home_cache.writable_real?
      Dir[home_cache/'*', home_cache/'.*'].each do |src|
        src = Pathname.new(src)
        next if ['.', '..'].include?(src.basename.to_s)
        FileUtils.mv src, HOMEBREW_CACHE
      end

      # We don't remove the empty ~/Library/Caches/Homebrew.  It was created
      # manually, and removing it could leave users insecure if they downgrade
      # to an older version.
      return
    end

    # Let's try the global cache instead.  This is tricky, because it might
    # be/have been owned by another user, and getting this wrong could lead to
    # privilege escalation.

    # Atomically get information about the path
    begin
      site_cache = Pathname.new("/Library/Caches/Homebrew")
      st = site_cache.lstat
    rescue Errno::ENOENT, Errno::EACCES
      return
    end

    # We can't do anything if it's not a directory that we can write to.
    return unless st.directory? and st.writable_real?

    # Don't migrate if it would be unsafe.
    # Note: This doesn't cover every possible unsafe situation that might
    # have been created by the current user, but it should cover the case
    # where a previous version of homebrew created a world-writable cache
    # directory.
    return if (st.mode & 2) != 0   # world-writable
    return if !st.owned? and st.uid != 0   # owned by another user
    return if st.symlink?  # is a symlink (potentially pointing somewhere dangerous)

    # Migrate the files.
    Dir[site_cache/'*', site_cache/'.*'].each do |src|
      src = Pathname.new(src)
      next if ['.', '..'].include?(src.basename.to_s)
      FileUtils.mv src, HOMEBREW_CACHE
    end

    # We don't remove the empty /Library/Caches/Homebrew directory, because
    # another process might be using it (hopefully not, but it's possible),
    # and deleting it might allow an attacker to create a new directory in
    # its place.
    return
  end
end
