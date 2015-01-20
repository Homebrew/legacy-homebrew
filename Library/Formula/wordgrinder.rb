class Wordgrinder < Formula
  homepage "http://wordgrinder.sourceforge.net"
  url "https://downloads.sourceforge.net/project/wordgrinder/wordgrinder/wordgrinder-0.5.2.tar.bz2"
  sha1 "4bcc600fbd110d9d87961feab15045b9b518b2db"

  depends_on "lua"
  depends_on "ncurses" => :build

  def install
    system "make"
    bin.install "bin/wordgrinder"
    man1.install "wordgrinder.man" => "wordgrinder.1"
    doc.install "README.wg"
  end

  test do
    system "#{bin}/wordgrinder", "-c", "#{doc}/README.wg", "#{testpath}/README.odt"
    assert (testpath/"README.odt").exist?
  end
end
