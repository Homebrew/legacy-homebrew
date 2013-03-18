require 'fileutils'

# We enhance FileUtils to make our Formula code more readable.
module FileUtils extend self

  # Create a temporary directory then yield. When the block returns,
  # recursively delete the temporary directory.
  def mktemp
    # I used /tmp rather than `mktemp -td` because that generates a directory
    # name with exotic characters like + in it, and these break badly written
    # scripts that don't escape strings before trying to regexp them :(

    # If the user has FileVault enabled, then we can't mv symlinks from the
    # /tmp volume to the other volume. So we let the user override the tmp
    # prefix if they need to.
    tmp = ENV['HOMEBREW_TEMP'].chuzzle || '/tmp'
    tempd = with_system_path { `mktemp -d #{tmp}/#{name}-XXXX` }.chuzzle
    raise "Failed to create sandbox" if tempd.nil?
    prevd = pwd
    cd tempd
    yield
  ensure
    cd prevd if prevd
    ignore_interrupts{ rm_r tempd } if tempd
  end

  # A version of mkdir that also changes to that folder in a block.
  alias mkdir_old mkdir
  def mkdir name, &block
    FileUtils.mkdir(name)
    if block_given?
      chdir name do
        yield
      end
    end
  end

  # The #copy_metadata method in all current versions of Ruby has a
  # bad bug which causes copying symlinks across filesystems to fail;
  # see #14710.
  # This was resolved in Ruby HEAD after the release of 1.9.3p194, but
  # as of September 2012 isn't in any released version of Ruby.
  # The monkey-patched method here is copied directly from upstream fix.
  if RUBY_VERSION < "1.9.3" or RUBY_PATCHLEVEL < 195
    class Entry_
      def copy_metadata(path)
        st = lstat()
        if !st.symlink?
          File.utime st.atime, st.mtime, path
        end
        begin
          if st.symlink?
            begin
              File.lchown st.uid, st.gid, path
            rescue NotImplementedError
            end
          else
            File.chown st.uid, st.gid, path
          end
        rescue Errno::EPERM
          # clear setuid/setgid
          if st.symlink?
            begin
              File.lchmod st.mode & 01777, path
            rescue NotImplementedError
            end
          else
            File.chmod st.mode & 01777, path
          end
        else
          if st.symlink?
            begin
              File.lchmod st.mode, path
            rescue NotImplementedError
            end
          else
            File.chmod st.mode, path
          end
        end
      end
    end
  end

  def rake *args
    system RUBY_BIN/'rake', *args
  end

  def ruby *args
    system RUBY_PATH, *args
  end
end
