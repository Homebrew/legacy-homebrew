class Jbig2dec < Formula
  homepage "http://ghostscript.com/jbig2dec.html"
  url "http://downloads.ghostscript.com/public/jbig2dec/jbig2dec-0.12.tar.gz"
  sha256 "bcc5f2cc75ee46e9a2c3c68d4a1b740280c772062579a5d0ceda24bee2e5ebf0"

  bottle do
    cellar :any
    sha1 "e00cb60ee3f381b625c0c9c6225102c1261fb1a0" => :mavericks
    sha1 "a9a442415f9dc5f61d6e487abe5dd1344f1483aa" => :mountain_lion
    sha1 "cbb4dfe055be243427210d03304c20760fb00bd7" => :lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fvi" # error: cannot find install-sh
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules", "--without-libpng"
    system "make", "install"
  end

  test do
    system "#{bin}/jbig2dec", "--version"
  end
end
