require 'formula'

class Valgrind < Formula
  homepage 'http://www.valgrind.org/'

  stable do
    url 'http://valgrind.org/downloads/valgrind-3.9.0.tar.bz2'
    sha1 '9415e28933de9d6687f993c4bb797e6bd49583f1'

    # Look for headers in the SDK on Xcode-only systems: https://bugs.kde.org/show_bug.cgi?id=295084
    if MacOS.version >= :mavericks
      depends_on "autoconf" => :build
      depends_on "automake" => :build
      depends_on "libtool" => :build

      patch do
        url "https://gist.githubusercontent.com/jacknagel/cd26a902d72aabd0b51d/raw/1b3c45a19c04ef096fd793c32ba13c037b1ad700/valgrind-sdk-paths-Makefile-am.diff"
        sha1 "38eeec10e13487a38d265e411f3066f1df058181"
      end
    else
      patch do
        url "https://gist.githubusercontent.com/jacknagel/369bedc191e0a0795358/raw/a2ec0cf5f5cbf960b95a643c45506479d6ef17c2/valgrind-sdk-paths-Makefile-in.diff"
        sha1 "8a1532d0696ce82f3b108fdee8d595015e7608e4"
      end
    end
  end

  head do
    url 'svn://svn.valgrind.org/valgrind/trunk'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # Look for headers in the SDK on Xcode-only systems: https://bugs.kde.org/show_bug.cgi?id=295084
    patch do
      url "https://gist.githubusercontent.com/jacknagel/cd26a902d72aabd0b51d/raw/1b3c45a19c04ef096fd793c32ba13c037b1ad700/valgrind-sdk-paths.diff"
      sha1 "38eeec10e13487a38d265e411f3066f1df058181"
    end
  end

  depends_on :macos => :snow_leopard

  # Valgrind needs vcpreload_core-*-darwin.so to have execute permissions.
  # See #2150 for more information.
  skip_clean 'lib/valgrind'

  # Fix for 10.7.4 w/XCode-4.5, duplicate symbols. Reported upstream in
  # https://bugs.kde.org/show_bug.cgi?id=307415
  patch do
    url "https://gist.githubusercontent.com/2bits/3784930/raw/dc8473c0ac5274f6b7d2eb23ce53d16bd0e2993a/patch2.diff"
    sha1 "6e57aa087fafd178b594e22fd0e00ea7c0eed438"
  end if MacOS.version == :lion

  # Fix for 10.9 Mavericks. From upstream bug:
  # https://bugs.kde.org/show_bug.cgi?id=326724#c12
  patch :p0 do
    url "http://bugsfiles.kde.org/attachment.cgi?id=83590"
    sha1 "22819a4a02140974e6330f3521b240b68f1619d7"
  end if MacOS.version == :mavericks

  # Fix for Snow Leopard from MacPorts
  patch :p0 do
    url "https://trac.macports.org/export/118697/trunk/dports/devel/valgrind/files/patch-compat-snowleo.diff"
    sha1 "ca22f4d49cfc9ea87469c2138b86c71f4b6b4d4d"
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

    if build.head? || MacOS.version == :mavericks
      inreplace "coregrind/Makefile.am", "@@HOMEBREW_SDKROOT@@", MacOS.sdk_path.to_s
      system "./autogen.sh"
    else
      inreplace "coregrind/Makefile.in", "@@HOMEBREW_SDKROOT@@", MacOS.sdk_path.to_s
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/valgrind", "ls", "-l"
  end
end
