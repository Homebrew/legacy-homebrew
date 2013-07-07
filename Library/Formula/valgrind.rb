require 'formula'

class Valgrind < Formula
  homepage 'http://www.valgrind.org/'

  # Valgrind 3.7.0 drops support for OS X 10.5
  if MacOS.version >= 10.6
    url 'http://valgrind.org/downloads/valgrind-3.8.1.tar.bz2'
    sha1 'aa7a3b0b9903f59a11ae518874852e8ccb12751c'
  else
    url "http://valgrind.org/downloads/valgrind-3.6.1.tar.bz2"
    sha1 "6116ddca2708f56e0a2851bdfbe88e01906fa300"
  end

  head 'svn://svn.valgrind.org/valgrind/trunk'

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  # Valgrind needs vcpreload_core-*-darwin.so to have execute permissions.
  # See #2150 for more information.
  skip_clean 'lib/valgrind'

  def patches
    # 1: For Xcode-only systems, we have to patch hard-coded paths, use xcrun &
    #    add missing CFLAGS. See: https://bugs.kde.org/show_bug.cgi?id=295084
    # 2: Fix for 10.7.4 w/XCode-4.5, duplicate symbols. Reported upstream in
    #    https://bugs.kde.org/show_bug.cgi?id=307415
    p = []
    p << 'https://gist.github.com/raw/3784836/f046191e72445a2fc8491cb6aeeabe84517687d9/patch1.diff' unless MacOS::CLT.installed?
    p << 'https://gist.github.com/raw/3784930/dc8473c0ac5274f6b7d2eb23ce53d16bd0e2993a/patch2.diff' if MacOS.version == :lion
    return p.empty? ? nil : p
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    if MacOS.prefer_64_bit?
      args << "--enable-only64bit" << "--build=amd64-darwin"
    else
      args << "--enable-only32bit"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system 'make'
    system "make install"
  end

  def test
    system "#{bin}/valgrind", "ls", "-l"
  end
end
