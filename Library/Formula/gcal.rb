class Gcal < Formula
  desc "Gcal is a program for calculating and printing calendars"
  homepage "https://www.gnu.org/software/gcal/"
  url "http://ftpmirror.gnu.org/gcal/gcal-4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcal/gcal-4.tar.xz"
  sha256 "59c5c876b12ec70649d90e2ce76afbe2f4ed93503d49ec39e5c575b3aef8ff6e"

  bottle do
    cellar :any
    sha256 "2298293a8e7a4ee03bc66d072e29d6e5b64d2f2ff40527bf5d6cb5cbcaf8d03b" => :yosemite
    sha256 "7080b2c3ab5e8f71a9ad76e42be2c6725c3178f0ccdcb849f1df7b2e557fd55c" => :mavericks
    sha256 "831f243692973ba051631f48001f5ddc2cee42302929f605e4e245f5b0e4031a" => :mountain_lion
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
