class Pcre2 < Formula
  homepage "http://www.pcre.org/"
  url "https://downloads.sourceforge.net/pcre/pcre2/10.00/pcre2-10.00.tar.bz2"
  mirror "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.00.tar.bz2"
  sha256 "487e605cf6ea273b416ad86fb8f2746c36f9959dcc730a6f49a4beca7c73888b"

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
