class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "http://www.valgrind.org/"

  stable do
    url "http://valgrind.org/downloads/valgrind-3.10.1.tar.bz2"
    sha256 "fa253dc26ddb661b6269df58144eff607ea3f76a9bcfe574b0c7726e1dfcb997"

    # Look for headers in the SDK on Xcode-only systems: https://bugs.kde.org/show_bug.cgi?id=295084
    # Fix duplicate symbols error on Lion: https://bugs.kde.org/show_bug.cgi?id=307415
    patch do
      url "https://gist.githubusercontent.com/jacknagel/369bedc191e0a0795358/raw/a71e6c0fdcb786fdfde2fc33d71d555b18bcfe8d/valgrind-sdk-paths-Makefile-in.diff"
      sha256 "ff8e8186af6985f9ffb8dca8fbea944e807d1caf144f320dca0f995d0417db7f"
    end

    # Revisit the below requirement with each release
    depends_on MaximumMacOSRequirement => :mavericks
  end

  bottle do
    sha1 "db2fd4ccbd7fb2d58a38480c76a312d00292f5d8" => :mavericks
    sha1 "98f60f0a39a6c97633ed5c6ff5a675979fc92861" => :mountain_lion
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
