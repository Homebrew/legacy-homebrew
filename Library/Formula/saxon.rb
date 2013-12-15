require 'formula'

class Saxon < Formula
  homepage "http://saxon.sourceforge.net"
  url 'http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.5/SaxonHE9-5-1-3J.zip'
  sha1 'a8cde14c9af99b40e52624253cf19ac4b1c02f16'
  version '9.5.1.3'

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'saxon9he.jar', 'saxon'
  end
end
