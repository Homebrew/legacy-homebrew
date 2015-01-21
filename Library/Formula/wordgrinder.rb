class Wordgrinder < Formula
  homepage "http://wordgrinder.sourceforge.net"
  url "https://downloads.sourceforge.net/project/wordgrinder/wordgrinder/wordgrinder-0.5.2.1.tar.bz2"
  sha1 "16578d7ac84e2542df6b8b5d3448cfdadbdd2790"

  depends_on "lua"

  def install
    system "make"
    system "make install PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/wordgrinder", "-c", "#{doc}/README.wg", "#{testpath}/README.odt"
    assert (testpath/"README.odt").exist?
  end
end
