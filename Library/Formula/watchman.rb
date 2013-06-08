require 'formula'

class Watchman < Formula
  homepage 'https://github.com/facebook/watchman'
  head 'git@github.com:facebook/watchman.git', :revision => '57e83b2e5ff2f24a3a61be43209ce4f4a6e4ffc9'
  url 'https://github.com/facebook/watchman/archive/v2.5.1.tar.gz'
  sha1 '8d3ebb1326f0542ffac95502cb92ea7fbf9e5adb'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'pcre' => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # the first time it doesn't build an internal json library
    system "make || true"
    # second time around works fine.
    system "make"
    system "make install"

    # display OSX specific notes about file handle size limits:
    ohai ''
    ohai 'The default per-process descriptor limit on OS X is extremely low (256!).'
    ohai 'Since kqueue() requires an open descriptor for each watched directory,'
    ohai 'you will very quickly run into resource limits if your trees are large.'
    ohai ''
    ohai 'See: https://github.com/facebook/watchman#max-os-file-descriptor-limits'
  end

  test do
    # TODO testing requires 'arc': https://github.com/facebook/watchman#tools
    system "false"
  end
end
