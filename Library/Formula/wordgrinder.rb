class Wordgrinder < Formula
  homepage "http://wordgrinder.sourceforge.net"
  url "https://downloads.sourceforge.net/project/wordgrinder/wordgrinder/wordgrinder-0.5.2.1.tar.bz2"
  sha1 "161702ccbe22ccc4d1b39e966e6ae1e0cc8f2255"

  depends_on "lua"

  def install
<<<<<<< HEAD
		system "make"
    system "make", "install", "PREFIX=#{prefix}"
=======
    system "make"
    system "make install PREFIX=#{prefix}"
>>>>>>> 0462d99d871d8cda3af0689211b1bbdc5882fca1
  end

  test do
    system "#{bin}/wordgrinder", "-c", "#{doc}/README.wg", "#{testpath}/README.odt"
    assert (testpath/"README.odt").exist?
  end
end
