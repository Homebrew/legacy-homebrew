class Gcal < Formula
  desc "Program for calculating and printing calendars"
  homepage "https://www.gnu.org/software/gcal/"
  url "http://ftpmirror.gnu.org/gcal/gcal-4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcal/gcal-4.tar.xz"
  sha256 "59c5c876b12ec70649d90e2ce76afbe2f4ed93503d49ec39e5c575b3aef8ff6e"

  bottle do
    cellar :any
    sha256 "bf90b61c3f45eb4e01381e4de84dfc72025966945fcf0bc3040af1ced2de5105" => :yosemite
    sha256 "845e43c2673d6e39d862f08de0dda0182c7d32cbf9f79afa90880d8d0cdfd83c" => :mavericks
    sha256 "dbdab2dbae31f459ded85d2ed50f6340930fdd9b7d42dac6df15213ace98d7a7" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    date = shell_output("date +%Y")
    assert_match date, shell_output("#{bin}/gcal")
  end
end
