class Jbig2dec < Formula
  homepage "http://ghostscript.com/jbig2dec.html"
  url "http://downloads.ghostscript.com/public/jbig2dec/jbig2dec-0.12.tar.gz"
  sha256 "bcc5f2cc75ee46e9a2c3c68d4a1b740280c772062579a5d0ceda24bee2e5ebf0"

  bottle do
    cellar :any
    sha256 "6879641659fe169b0850f36ab4c283e21c48238d0a2bc79f3236091f3c5330c6" => :yosemite
    sha256 "a88cf6fcfc00bfb64da10c9d8fba6a34c2ca8c01256b4f2569c592b90dd5decc" => :mavericks
    sha256 "e3cb8234b3db31f2b15ee2951ba0e307afbe67cb9bbc560e8bf661dd687c474f" => :mountain_lion
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
