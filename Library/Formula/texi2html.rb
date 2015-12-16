class Texi2html < Formula
  desc "Convert TeXinfo files to HTML"
  homepage "http://www.nongnu.org/texi2html/"
  url "http://download.savannah.gnu.org/releases/texi2html/texi2html-5.0.tar.gz"
  sha256 "e60edd2a9b8399ca615c6e81e06fa61946ba2f2406c76cd63eb829c91d3a3d7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "75d7f657b619df77f6242cf24f07819730bd3907b1a74f683d54a4d2fb351fb2" => :el_capitan
    sha256 "3c3922e7c49aa3a0e1c02c845fd186d6feb1832067801d07168ef311960bdbf3" => :yosemite
    sha256 "b38ff58a22f0b79bc719bd16c987af8cd6673230f150eaac5d11c886e5a3883a" => :mavericks
  end

  keg_only :provided_pre_mountain_lion

  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--mandir=#{man}", "--infodir=#{info}"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    (testpath/"test.texinfo").write <<-EOS.undent
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system "#{bin}/texi2html", "test.texinfo"
    assert_match /Hello World!/, File.read("test.html")
  end
end
