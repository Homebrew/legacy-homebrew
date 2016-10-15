class GalenBin < Formula
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-1.4.10/galen-bin-1.4.10.zip"
  sha1 "237896138a244d1a168a3220d07edd88f6f39da9"

  depends_on :java => "1.6"

  def install
    bin.install "galen", "galen.jar"
  end

  test do
    system "#{bin}/galen", "-v"
  end
end
