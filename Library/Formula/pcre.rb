class Pcre < Formula
  homepage "http://www.pcre.org/"
  url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.37.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/pcre/pcre/8.37/pcre-8.37.tar.bz2"
  sha256 "51679ea8006ce31379fb0860e46dd86665d864b5020fc9cd19e71260eef4789d"

  bottle do
    cellar :any
    sha1 "b3e7d1cb382ab41fe260cb8c75e96ba45167044f" => :yosemite
    sha1 "3b585fa4fdcd0e1906f6a732809c2e6b015fec2c" => :mavericks
    sha1 "4d48f013859cc1ca72467d4802d1d5d6b06ad542" => :mountain_lion
  end

  option :universal

  fails_with :llvm do
    build 2326
    cause "Bus error in ld on SL 10.6.4"
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-utf8",
                          "--enable-pcre8",
                          "--enable-pcre16",
                          "--enable-pcre32",
                          "--enable-unicode-properties",
                          "--enable-pcregrep-libz",
                          "--enable-pcregrep-libbz2",
                          "--enable-jit"
    system "make"
    ENV.deparallelize
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/pcregrep", "regular expression", "#{prefix}/README"
  end
end
