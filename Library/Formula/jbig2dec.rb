class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "http://ghostscript.com/jbig2dec.html"
  url "http://downloads.ghostscript.com/public/jbig2dec/jbig2dec-0.12.tar.gz"
  sha256 "bcc5f2cc75ee46e9a2c3c68d4a1b740280c772062579a5d0ceda24bee2e5ebf0"

  bottle do
    cellar :any
    revision 1
    sha256 "38ad008992a9c273162238783b31bbcc4be8558d82c0a87b947ef0be699c437c" => :el_capitan
    sha256 "d1de5bcbceaca8669c847ec754e7d44b844ad08abdef377efdd704e768d13c86" => :yosemite
    sha256 "e42e117812549edeae1f60e1900b0692994c75ebae186f611e16528fe0521c89" => :mavericks
    sha256 "42039ee0b62ad6b4a153c5a5e93609ac1b668626b044a23a450a58d4d71338a5" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "libpng" => :optional

  # http://bugs.ghostscript.com/show_bug.cgi?id=695890
  # Remove on next release.
  patch do
    url "http://git.ghostscript.com/?p=jbig2dec.git;a=commitdiff_plain;h=70c7f1967f43a94f9f0d6808d6ab5700a120d2fc"
    sha256 "5239e4eb991f198d2ba30d08011c2887599b5cead9db8b1d3eacec4b8912c2d0"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
    ]

    args << "--without-libpng" if build.without? "libpng"

    system "autoreconf", "-fvi" # error: cannot find install-sh
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/jbig2dec", "--version"
  end
end
