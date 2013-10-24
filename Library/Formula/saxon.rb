require 'formula'

class Saxon < Formula
  homepage "http://saxon.sourceforge.net"
  url "http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.5/SaxonHE9-5-0-2J.zip"
  sha1 'd599b177d01cde8b2a5a2a5c0d6f61e65e7d48df'
  version "9.5.0.2"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'saxon9he.jar', 'saxon'
  end
end
