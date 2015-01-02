class XmlCoreutils < Formula
  homepage "http://www.lbreyer.com/xml-coreutils.html"
  url "http://www.lbreyer.com/gpl/xml-coreutils-0.8.1.tar.gz"
  sha1 "fd73b2a087ea1c630571070b1ab4ea3b40138a46"

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
