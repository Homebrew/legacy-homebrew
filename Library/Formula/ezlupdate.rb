class Ezlupdate < Formula
  desc "Create .ts files for eZ publish"
  homepage "http://ezpedia.org/ez/ezlupdate"
  url "https://github.com/ezsystems/ezpublish-legacy/archive/v2015.01.3.tar.gz"
  sha256 "cb365cfad2f5036908dc60bbca599383fc2b61435682dacacdb7bf27ff427ce6"

  head "https://github.com/ezsystems/ezpublish-legacy.git"

  bottle do
    cellar :any
    sha256 "68df4f04b7e23877182f848c3626eeb6a7b6ea677042736252e337e91216fa53" => :yosemite
    sha256 "c9ba7248ae420ad5b53cabe1a9184bac07894ec86199d024f60eaff7a3f185a6" => :mavericks
    sha256 "4c09e545f0e9f011ed6d281a2eb3b53a5dfba04ddd4a5c6df2bc3628a285b8b5" => :mountain_lion
  end

  depends_on "qt"

  def install
    cd "support/ezlupdate-qt4.5/ezlupdate" do
      # Use the qmake installation done with brew
      # because others installations can make a mess
      system "#{HOMEBREW_PREFIX}/bin/qmake", "ezlupdate.pro"
      system "make"
    end
    bin.install "bin/macosx/ezlupdate"
  end

  test do
    (testpath/"share/translation").mkpath
    system "#{bin}/ezlupdate", "-v", "eng-GB"
  end
end
