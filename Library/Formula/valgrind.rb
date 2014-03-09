require 'formula'

class Valgrind < Formula
  homepage 'http://www.valgrind.org/'

  stable do
    url 'http://valgrind.org/downloads/valgrind-3.9.0.tar.bz2'
    sha1 '9415e28933de9d6687f993c4bb797e6bd49583f1'

    if MacOS.version == :mavericks
      depends_on :autoconf
      depends_on :automake
      depends_on :libtool
    end
  end

  head do
    url 'svn://svn.valgrind.org/valgrind/trunk'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on :macos => :snow_leopard

  # Valgrind needs vcpreload_core-*-darwin.so to have execute permissions.
  # See #2150 for more information.
  skip_clean 'lib/valgrind'

  def patches
    # 1: For Xcode-only systems, we have to patch hard-coded paths, use xcrun &
    #    add missing CFLAGS. See: https://bugs.kde.org/show_bug.cgi?id=295084
    # 2: Fix for 10.7.4 w/XCode-4.5, duplicate symbols. Reported upstream in
    #    https://bugs.kde.org/show_bug.cgi?id=307415
    # 3: Fix for 10.9 Mavericks. From upstream bug:
    #    https://bugs.kde.org/show_bug.cgi?id=326724#c12
    p = { :p1 => [] }
    p[:p1] << 'https://gist.github.com/raw/3784836/f046191e72445a2fc8491cb6aeeabe84517687d9/patch1.diff' unless MacOS::CLT.installed?
    p[:p1] << 'https://gist.github.com/raw/3784930/dc8473c0ac5274f6b7d2eb23ce53d16bd0e2993a/patch2.diff' if MacOS.version == :lion
    p[:p0] = 'http://bugsfiles.kde.org/attachment.cgi?id=83590' if MacOS.version == :mavericks
    p
  end

  def install
    if (build.head? || MacOS.version == :mavericks) && ENV.compiler == :clang
      # Clang does not support '-mno-dynamic-no-pic'. Before clang 3.4,
      # this is simply a warning, however, with clang 3.4 and later,
      # this becomes a fatal error.
      #
      # Reported upstream in https://bugs.kde.org/show_bug.cgi?id=330257
      inreplace 'Makefile.all.am', '-mno-dynamic-no-pic', ''
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    if MacOS.prefer_64_bit?
      args << "--enable-only64bit" << "--build=amd64-darwin"
    else
      args << "--enable-only32bit"
    end

    system "./autogen.sh" if build.head? || MacOS.version == :mavericks
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/valgrind", "ls", "-l"
  end
end
