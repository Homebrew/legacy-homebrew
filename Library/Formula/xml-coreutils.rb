class XmlCoreutils < Formula
  desc "Powerful interactive system for text processing"
  homepage "http://www.lbreyer.com/xml-coreutils.html"
  url "http://www.lbreyer.com/gpl/xml-coreutils-0.8.1.tar.gz"
  sha256 "7fb26d57bb17fa770452ccd33caf288deee1d757a0e0a484b90c109610d1b7df"

  bottle do
    sha256 "dc5419dfd0f0f7214426961d12b8b4b72d34f3b37a8c7768294499b15a3239db" => :yosemite
    sha256 "4aa1252d1384fa5872c77d32c8a9213458c7158e4e60a75d4c6cf65b90701a26" => :mavericks
    sha256 "6920e81b3d9fc7b9c3910ee273db6cb55ed7236d5edea3591a00b75536655a06" => :mountain_lion
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
