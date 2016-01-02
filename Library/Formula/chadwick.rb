class Chadwick < Formula
  desc "Tools for parsing Retrosheet MLB play-by-play files."
  homepage "http://chadwick.sourceforge.net/doc/index.html"
  url "https://downloads.sourceforge.net/project/chadwick/chadwick-0.6/chadwick-0.6.4/chadwick-0.6.4.tar.gz"
  sha256 "2fcc44b4110c3aebf8b9f3daaccf22ccaba3760d3d878e65d38b86127b913559"

  bottle do
    cellar :any
    revision 1
    sha256 "cb7f68f0b7e1c858eb6f33018ab811f6c1a629ca6f59028cd0adb88086addc12" => :el_capitan
    sha256 "ac3cc02a4bf29fa948483fe6362ac51e475331904b966229da43c98b039f36da" => :yosemite
    sha256 "0e550047558d9108dc2c01b279ea00fbe68b3c0e103349e24b49bfd1c57d8436" => :mavericks
  end

  resource "event_files" do
    url "http://www.retrosheet.org/events/2014eve.zip"
    sha256 "f2bdcf2c587ea8b67d5c5485edad67c688a8e02325c2b787362ab360b79abdbd"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    resource("event_files").stage testpath
    output = shell_output("#{bin}/cwbox -i ATL201404080 -y 2014 2014ATL.EVN")
    assert_match "Game of 4/8/2014 -- New York at Atlanta", output
    assert_equal 0, $?.exitstatus
  end
end
