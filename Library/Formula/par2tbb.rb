require 'formula'

class Par2tbb < Formula
  homepage 'http://chuchusoft.com/par2_tbb/'
  url 'http://chuchusoft.com/par2_tbb/par2cmdline-0.4-tbb-20141125.tar.gz'
  sha256 '17a5bb5e63c1b9dfcf5feb5447cee60a171847be7385d95f1e2193a7b59a01ad'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on 'tbb'

  conflicts_with "par2",
    :because => "par2tbb and par2 install the same binaries."

  fails_with :clang do
    build 318
  end

  def install
    system "autoreconf", "-fvi"
    # par2tbb expects to link against 10.4 / 10.5 SDKs
    inreplace "Makefile.in", /^.*-mmacosx-version.*$/, ""

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/'test.out').write "test"
    system "#{bin}/par2", 'create', 'test', 'test.out'
    system "#{bin}/par2", 'verify', 'test.par2'
  end
end
