class Gcal < Formula
  desc "Program for calculating and printing calendars"
  homepage "https://www.gnu.org/software/gcal/"
  url "http://ftpmirror.gnu.org/gcal/gcal-4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcal/gcal-4.tar.xz"
  sha256 "59c5c876b12ec70649d90e2ce76afbe2f4ed93503d49ec39e5c575b3aef8ff6e"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "32c335802cde011da010be16d71198be297309c6b9fefe0a6940271e037dceb1" => :el_capitan
    sha256 "e7f8fa3ae065b6ba9f1b231228dd498a7154098433249c565165da3713870ece" => :yosemite
    sha256 "3b6cef64c1612a4e2858d8562972ba8aaf382968a4d92a790e814d581750807a" => :mavericks
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
