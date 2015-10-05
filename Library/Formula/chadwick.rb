class Chadwick < Formula
  desc "Chadwick tools for parsing Retrosheet MLB play-by-play files."
  homepage "http://chadwick.sourceforge.net/doc/index.html"
  url "https://downloads.sourceforge.net/project/chadwick/chadwick-0.6/chadwick-0.6.4/chadwick-0.6.4.tar.gz"
  sha256 "2fcc44b4110c3aebf8b9f3daaccf22ccaba3760d3d878e65d38b86127b913559"

  bottle do
    cellar :any
    sha256 "e8e371df4cea6f75347381c35051fe784d20ddda26a4d0e33e606aa97cbcf41f" => :yosemite
    sha256 "259937aa138f1a8ed2a3d86b934de8bbab7f33ec409eb17e2554fa59fcd3c8c0" => :mavericks
    sha256 "fa568f6ce7e241f3f0b65920b4cc47c5879622b9f18e2521643799bf973fe86e" => :mountain_lion
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
