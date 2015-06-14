require "formula"

class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "http://saxon.sourceforge.net"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.6/SaxonHE9-6-0-5J.zip"
  sha1 "10bb2091e8b891065918ff55c01190fab38acc85"
  version "9.6.0.5"

  def install
    libexec.install Dir["*.jar", "doc", "notices"]
    bin.write_jar_script libexec/"saxon9he.jar", "saxon"
  end
end
