require 'formula'

class Saxon < Formula
  homepage "http://saxon.sourceforge.net"
  url 'https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.5/SaxonHE9-5-1-4J.zip'
  sha1 '10910a1ced9c1a485a6084d4a6f1a6793645a798'
  version '9.5.1.4'

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'saxon9he.jar', 'saxon'
  end
end
