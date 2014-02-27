require 'formula'

class Saxon < Formula
  homepage "http://saxon.sourceforge.net"
  url 'https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.5/SaxonHE9-5-1-3J.zip'
  sha1 '68ca55a1b13d404a152098f003ff5b3a6941784e'
  version '9.5.1.3'

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'saxon9he.jar', 'saxon'
  end
end
