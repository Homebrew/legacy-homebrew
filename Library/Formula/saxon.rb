require 'formula'

class Saxon < Formula
  homepage "http://saxon.sourceforge.net"
  url "http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.4/SaxonHE9-4-0-2J.zip"
  sha1 '7383d2504f45582f94c0d9c9ca2f4fa322fad7a1'
  version "9.4.0.2"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'saxon9he.jar', 'saxon'
  end
end
