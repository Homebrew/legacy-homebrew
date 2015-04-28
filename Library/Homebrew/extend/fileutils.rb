require "fileutils"
require "tmpdir"

# We enhance FileUtils to make our Formula code more readable.
module FileUtils

  # Create a temporary directory then yield. When the block returns,
  # recursively delete the temporary directory.
  def mktemp(prefix=name)
    prev = pwd
    tmp  = Dir.mktmpdir(prefix, HOMEBREW_TEMP)

    begin
      cd(tmp)

      begin
        yield
      ensure
        cd(prev)
      end
    ensure
      ignore_interrupts { rm_rf(tmp) }
    end
  end
  module_function :mktemp

  # A version of mkdir that also changes to that folder in a block.
  alias_method :old_mkdir, :mkdir
  def mkdir name, &block
    old_mkdir(name)
    if block_given?
      chdir name do
        yield
      end
    end
  end
  module_function :mkdir

  # The #copy_metadata method in all current versions of Ruby has a
  # bad bug which causes copying symlinks across filesystems to fail;
  # see #14710.
  # This was resolved in Ruby HEAD after the release of 1.9.3p194, but
  # never backported into the 1.9.3 branch. Fixed in 2.0.0.
  # The monkey-patched method here is copied directly from upstream fix.
  if RUBY_VERSION < "2.0.0"
    class Entry_
      alias_method :old_copy_metadata, :copy_metadata
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

  private

  # Run scons using a Homebrew-installed version, instead of whatever
  # is in the user's PATH
  def scons *args
    system Formulary.factory("scons").opt_bin/"scons", *args
  end

  def rake *args
    system RUBY_BIN/'rake', *args
  end

  alias_method :old_ruby, :ruby if method_defined?(:ruby)
  def ruby *args
    system RUBY_PATH, *args
  end

  def xcodebuild *args
    removed = ENV.remove_cc_etc
    system "xcodebuild", *args
  ensure
    ENV.update(removed)
  end
end
