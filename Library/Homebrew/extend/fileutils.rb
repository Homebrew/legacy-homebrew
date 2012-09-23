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
    tempd = `/usr/bin/mktemp -d #{tmp}/brew-#{name}-#{version}-XXXX`.chuzzle
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

end
