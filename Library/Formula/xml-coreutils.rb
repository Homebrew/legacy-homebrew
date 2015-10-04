class XmlCoreutils < Formula
  desc "Powerful interactive system for text processing"
  homepage "http://www.lbreyer.com/xml-coreutils.html"
  url "http://www.lbreyer.com/gpl/xml-coreutils-0.8.1.tar.gz"
  sha256 "7fb26d57bb17fa770452ccd33caf288deee1d757a0e0a484b90c109610d1b7df"

  bottle do
    sha1 "00c4b58c3d0f45bf14519baea85a0ed0045c0bda" => :yosemite
    sha1 "aaf22770ac1eea29e10da913ef6b2d0b01063a9a" => :mavericks
    sha1 "b8f7c130dee98bd6d60d52bd4bff95b0eb13b981" => :mountain_lion
  end

  depends_on "s-lang"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.xml").write <<-EOS.undent
      <hello>world!</hello>
    EOS
    assert_match /0\s+1\s+1/, shell_output("#{bin}/xml-wc test.xml")
  end
end
