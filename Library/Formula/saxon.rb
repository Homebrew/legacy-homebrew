require 'formula'

class Saxon < Formula
  homepage "http://saxon.sourceforge.net"
  url "http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.5/SaxonHE9-5-1-1J.zip"
  sha1 '5b5ff1f047d5206d4a70e705358dd5f7c9feaf78'
  version "9.5.1.1"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'saxon9he.jar', 'saxon'
  end
end
