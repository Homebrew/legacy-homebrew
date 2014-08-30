require 'formula'

class Cloog < Formula
  homepage 'http://www.cloog.org/'
  url 'http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.1.tar.gz'
  mirror 'http://gcc.cybermirror.org/infrastructure/cloog-0.18.1.tar.gz'
  sha1 '2dc70313e8e2c6610b856d627bce9c9c3f848077'

  bottle do
    cellar :any
    revision 1
    sha1 '38afdce382abcd3c46fb94af7eb72e87d87859d4' => :mavericks
    sha1 'd6984ce335cf7b8eb482cdd4f0301c6583b00073' => :mountain_lion
    sha1 'fd707268c3e5beafa9b98a768f7064d5b9699178' => :lion
  end

  head do
    url 'http://repo.or.cz/r/cloog.git'
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'gmp'
  depends_on 'isl'

  def install
    system "./autogen.sh" if build.head?

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-gmp=system",
      "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
      "--with-isl=system",
      "--with-isl-prefix=#{Formula["isl"].opt_prefix}"
    ]

    args << "--with-osl=bundled" if build.head?

    system "./configure", *args
    system "make install"
  end

  test do
    cloog_source = <<-EOS.undent
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    output = pipe_output("#{bin}/cloog /dev/stdin", cloog_source)
    assert_match /Generated from \/dev\/stdin by CLooG/, output
  end
end
