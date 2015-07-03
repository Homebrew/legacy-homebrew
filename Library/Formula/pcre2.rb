class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "http://www.pcre.org/"
  url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.20.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/downloads.sourceforge.net/p/pc/pcre/pcre2/10.20/pcre2-10.20.tar.bz2"
  sha256 "332e287101c9e9567d1ed55391b338b32f1f72c5b5ee7cc81ef2274a53ad487a"

  head "svn://vcs.exim.org/pcre2/code/trunk"

  bottle do
    cellar :any
    sha256 "9a4896919f904bea9e6c9537b9e857603181ee8c33ae0198b89c2fff98f7108a" => :yosemite
    sha256 "8691bf0337543eb899d42ff68455a595835cd45859a682a324f5b54905e638cf" => :mavericks
    sha256 "15de436975d7b9409442c128c30aeec9e63c0c6ff4286f2abeea8706c0336730" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-pcre2-16",
                          "--enable-pcre2-32",
                          "--enable-pcre2grep-libz",
                          "--enable-pcre2grep-libbz2",
                          "--enable-jit"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pcre2grep", "regular expression", "#{prefix}/README"
  end
end
