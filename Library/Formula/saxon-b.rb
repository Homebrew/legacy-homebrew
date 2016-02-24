class SaxonB < Formula
  desc "XSLT and XQuery processor"
  homepage "http://saxon.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-B/9.1.0.8/saxonb9-1-0-8j.zip"
  version "9.1.0.8"
  sha256 "92bcdc4a0680c7866fe5828adb92c714cfe88dcf3fa0caf5bf638fcc6d9369b4"

  bottle :unneeded

  def install
    (buildpath/"saxon-b").install Dir["*.jar", "doc", "notices"]
    share.install Dir["*"]
  end
end
