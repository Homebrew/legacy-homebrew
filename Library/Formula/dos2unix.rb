require 'brewkit'

class Dos2unix <Formula
  url 'http://www.sfr-fresh.com/linux/misc/old/dos2unix-3.1.tar.gz'
  md5 '25ff56bab202de63ea6f6c211c416e96'
  homepage 'http://www.sfr-fresh.com/linux/misc/'

  def install
    File.unlink 'dos2unix'

    # we don't use the Makefile as it doesn't optimize
    system "#{ENV.cc} #{ENV['CFLAGS']} dos2unix.c -o dos2unix"

    # make install is broken due to INSTALL file, but also it sucks so we'll do it
    # also Ruby 1.8 is broken, it won't allow you to move a symlink that's
    # target is invalid. FFS very dissapointed with dependability of 
    # fundamental Ruby functions. Maybe we shouldn't use them?
    # Anyway, that is why the symlink is installed first.
    bin.install %w[mac2unix dos2unix]
    man1.install %w[mac2unix.1 dos2unix.1]
  end
end
