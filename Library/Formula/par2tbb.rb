require 'formula'

class Par2tbb < Formula
  homepage 'http://chuchusoft.com/par2_tbb/'
  url 'http://chuchusoft.com/par2_tbb/par2cmdline-0.4-tbb-20100203.tar.gz'
  sha1 '6453ab5f0ee76800fdfdb5d10fe607250c9ea330'

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
