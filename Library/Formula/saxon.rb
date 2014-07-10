require "formula"

class Saxon < Formula
  homepage "http://saxon.sourceforge.net"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.5/SaxonHE9-5-1-5J.zip"
  sha1 "bb8476866cacb72e5567bdfc246570e7f0986e48"
  version "9.5.1.5"

  def install
    libexec.install Dir["*.jar", "doc", "notices"]
    bin.write_jar_script libexec/"saxon9he.jar", "saxon"
  end
end
