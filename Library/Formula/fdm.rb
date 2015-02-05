class Fdm < Formula
  homepage "http://sourceforge.net/projects/fdm/"
  url "https://downloads.sourceforge.net/project/fdm/fdm/fdm-1.8/fdm-1.8.tar.gz"
  sha1 "25c0ebc0c2b43984d04c82d0ba3909acf7403df7"

  depends_on "tdb"
  depends_on "openssl"

  def install
    # fdm 1.8 uses an environment variable to set $PREFIX,
    # the --prefix param to configure is ignored.
    ENV["PREFIX"] = "#{prefix}"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    bin.install "fdm"
    man1.install "fdm.1"
    man5.install "fdm.conf.5"
  end
end
