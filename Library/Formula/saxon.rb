require "formula"

class Saxon < Formula
  homepage "http://saxon.sourceforge.net"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.5/SaxonHE9-5-1-6J.zip"
  sha1 "b5f392bc8d2328979e776ad53198d5d7dc1d65a2"
  version "9.5.1.6"

  def install
    libexec.install Dir["*.jar", "doc", "notices"]
    bin.write_jar_script libexec/"saxon9he.jar", "saxon"
  end
end
