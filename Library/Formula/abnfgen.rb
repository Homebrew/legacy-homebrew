class Abnfgen < Formula
  desc "Quickly generate random documents that match an ABFN grammar"
  homepage "http://www.quut.com/abnfgen/"
  url "http://www.quut.com/abnfgen/abnfgen-0.16.tar.gz"
  sha256 "c256712a97415c86e1aa1847e2eac00019ca724d56b8ee921d21b258090d333a"

  bottle do
    cellar :any
    sha256 "dbeb98b3292f61f3fcb2dab6ff49c676a71a102deae81c5de2d94c6bd1e2760d" => :yosemite
    sha256 "a6ee5ffd408c8359664f46817718dc41fb287cb61968659a4e7637a094160025" => :mavericks
    sha256 "cfd7d1f79d6b8ea5fb333405043e45b7f9b403de59420bcb3dba3770cea444b7" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"grammar").write %(ring = 1*12("ding" SP) "dong" CRLF)
    system "#{bin}/abnfgen", (testpath/"grammar")
  end
end
