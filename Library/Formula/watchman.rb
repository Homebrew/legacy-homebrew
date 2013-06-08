require 'formula'

class Watchman < Formula
  homepage 'https://github.com/facebook/watchman'
  head 'https://github.com/facebook/watchman.git'
  url 'https://github.com/facebook/watchman/archive/v2.5.1.tar.gz'
  sha1 '8d3ebb1326f0542ffac95502cb92ea7fbf9e5adb'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'pcre'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # the first time it doesn't build an internal json library
    # See: https://github.com/facebook/watchman/issues/6
    system "make || true"
    # second time around works fine.
    system "make"
    system "make install"
  end

  def caveats
    # display OSX specific notes about file handle size limits:
    <<-EOS.undent

    The default per-process descriptor limit on current versions of OS X is
    extremely low (256!). Since kqueue() requires an open descriptor for each
    watched directory, you will very quickly run into resource limits if your trees
    are large or if you do not raise the limits in your system configuration.

    Watchman will attempt to raise its descriptor limit to match
    kern.maxfilesperproc when it starts up, so you shouldn't need to mess with
    ulimit; just raising the sysctl should do the trick.

    The following will raise the limits to allow 10 million files total, with 1
    million files per process until your next reboot.

    sudo sysctl -w kern.maxfiles=10485760
    sudo sysctl -w kern.maxfilesperproc=1048576

    Putting the following into a file named /etc/sysctl.conf on OS X will cause
    these values to persist across reboots:

    kern.maxfiles=10485760
    kern.maxfilesperproc=1048576
    
    For more information see https://github.com/facebook/watchman#max-os-file-descriptor-limits

    EOS
  end

  test do
    # TODO testing requires 'arc': https://github.com/facebook/watchman#tools
    system "false"
  end
end
