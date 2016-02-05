class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "http://www.pcre.org/"
  url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.20.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/downloads.sourceforge.net/p/pc/pcre/pcre2/10.20/pcre2-10.20.tar.bz2"
  sha256 "332e287101c9e9567d1ed55391b338b32f1f72c5b5ee7cc81ef2274a53ad487a"

  head "svn://vcs.exim.org/pcre2/code/trunk"

  bottle do
    cellar :any
    sha256 "df6f0855251cd664b41896e72262d28ed73b82b585b09d5df1a8d54783c8583c" => :el_capitan
    sha256 "acd343182f0033d61a8b9266909a1c3a609d9a450d1cf28fe30fefa9c54c36e3" => :yosemite
    sha256 "febc1cf22e5da7f4f873dadda0d88a158602d99b49d61ed51441d82083a9b924" => :mavericks
    sha256 "5258f37a0149806a78d777c6c311ff9c53eff4d4ae3d14c47825f4c279eed298" => :mountain_lion
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
