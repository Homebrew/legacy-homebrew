class Lcab < Formula
  desc "Cabinet file creation tool"
  homepage "http://ohnopub.net/~ohnobinki/lcab/"
  url "http://mirror.ohnopub.net/mirror/lcab-1.0b12.tar.gz"
  mirror "https://launchpad.net/ubuntu/intrepid/+source/lcab/1.0b12-3/+files/lcab_1.0b12.orig.tar.gz"
  sha256 "065f2c1793b65f28471c0f71b7cf120a7064f28d1c44b07cabf49ec0e97f1fc8"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "7a6d3c838ed1ac609c130954379432cfab8558f8898117360ae7a70fbc28b743" => :el_capitan
    sha256 "1f17ca05d8365b47b6cd9949e985a99bedf1dc6b4cb0dcf88715e02e584433d8" => :yosemite
    sha256 "56f01c24e8814d4a719597bb364c1c94d38e45f57ae216d349aa05056c67e78a" => :mavericks
  end

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
