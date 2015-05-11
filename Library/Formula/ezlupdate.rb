class Ezlupdate < Formula
  homepage "http://ezpedia.org/ez/ezlupdate"
  url "https://github.com/ezsystems/ezpublish-legacy/archive/v2015.01.2.tar.gz"
  sha256 "17ce825bc4b85a1c84f7d23b1f8ff0099c0272038be360aca243dda112514f6c"

  head "https://github.com/ezsystems/ezpublish-legacy.git"

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
