class Vilistextum < Formula
  desc "HTML to text converter"
  homepage "http://bhaak.net/vilistextum/"
  url "http://bhaak.net/vilistextum/vilistextum-2.6.9.tar.gz"
  sha1 "d62fe5213b61c0d0356bb2e60757dd535ac0a82b"

  bottle do
    cellar :any
    sha1 "8d29715464dd1faf569cb74fb673401b0e507ecc" => :yosemite
    sha1 "28f4fe3151aca197383f409486840106d307355b" => :mavericks
    sha1 "c11e4458f504653f89b98e5058534282929cfa53" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/vilistextum", "-v"
  end
end
