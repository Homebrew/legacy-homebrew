class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "http://www.valgrind.org/"

  stable do
    url "http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2"
    sha256 "6c396271a8c1ddd5a6fb9abe714ea1e8a86fce85b30ab26b4266aeb4c2413b42"
  end

  bottle do
    sha256 "c747fd1c9b09ac4bc186bf5294317cd506ce1fd733b892b7df19c68e39505670" => :el_capitan
    sha256 "d2200eebec692898c5684a837cf96832fbd877cc92ec57d1e9730e454a9e94c5" => :yosemite
    sha256 "6bb14866f48391c2d1f44f7acd2c6fd709221f890147608b176ccfa49198a251" => :mavericks
  end

  head do
    url "svn://svn.valgrind.org/valgrind/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/valgrind", "ls", "-l"
  end
end
