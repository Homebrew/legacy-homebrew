require "formula"

class Valgrind < Formula
  homepage "http://www.valgrind.org/"

  stable do
    url "http://valgrind.org/downloads/valgrind-3.10.0.tar.bz2"
    sha1 "aec0b8cd042ec36c8cce4f6027b98627ab202f26"

    # Look for headers in the SDK on Xcode-only systems: https://bugs.kde.org/show_bug.cgi?id=295084
    # Fix duplicate symbols error on Lion: https://bugs.kde.org/show_bug.cgi?id=307415
    patch do
      url "https://gist.githubusercontent.com/jacknagel/369bedc191e0a0795358/raw/a71e6c0fdcb786fdfde2fc33d71d555b18bcfe8d/valgrind-sdk-paths-Makefile-in.diff"
      sha1 "4210431e2a12c191875391b144b9a45cc76496c1"
    end
  end

  bottle do
    sha1 "9753777bbde53cd9c33eb7e1dba9daed8ee6d960" => :mavericks
    sha1 "a7209c76aae1bfbdd9af3acf7a5d3aa022299f1e" => :mountain_lion
    sha1 "93a7501abcd251d1d9f4f6763bbba693ee953909" => :lion
  end

  head do
    url "svn://svn.valgrind.org/valgrind/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # Look for headers in the SDK on Xcode-only systems: https://bugs.kde.org/show_bug.cgi?id=295084
    # Fix duplicate symbols error on Lion: https://bugs.kde.org/show_bug.cgi?id=307415
    patch do
      url "https://gist.githubusercontent.com/jacknagel/cd26a902d72aabd0b51d/raw/1a61a328a87a728dccbeef0594f6fe335e9bf917/valgrind-sdk-paths-Makefile-am.diff"
      sha1 "d004d6af97f7f74d49d09dc513b4c67488da0a45"
    end
  end

  depends_on :macos => :snow_leopard
  # Revisit the below requirement with each release
  depends_on MaximumMacOSRequirement => :mavericks

  # Valgrind needs vcpreload_core-*-darwin.so to have execute permissions.
  # See #2150 for more information.
  skip_clean "lib/valgrind"

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

    ext = build.head? ? "am" : "in"
    inreplace "coregrind/Makefile.#{ext}", "@@HOMEBREW_SDKROOT@@", MacOS.sdk_path.to_s

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/valgrind", "ls", "-l"
  end
end
