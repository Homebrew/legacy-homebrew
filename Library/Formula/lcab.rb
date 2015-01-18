class Lcab < Formula
  homepage "http://ohnopub.net/~ohnobinki/lcab/"
  url "ftp://mirror.ohnopub.net/mirror/lcab-1.0b12.tar.gz"
  mirror "https://launchpad.net/ubuntu/intrepid/+source/lcab/1.0b12-3/+files/lcab_1.0b12.orig.tar.gz"
  sha1 "3e5a1f23f0ea1c991e80322592e3ede9f38ecd94"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").write "a test"

    system "#{bin}/lcab", "test", "test.cab"
    assert File.exist? "test.cab"
  end
end
