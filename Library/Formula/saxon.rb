class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "http://saxon.sourceforge.net"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.6/SaxonHE9-6-0-5J.zip"
  sha256 "b39be0c675bcaa6b1e63f4cca7b194a7cca1a847f5937c16ce5568f0b2a0cabe"
  version "9.6.0.5"

  def install
    libexec.install Dir["*.jar", "doc", "notices"]
    bin.write_jar_script libexec/"saxon9he.jar", "saxon"
  end
end
