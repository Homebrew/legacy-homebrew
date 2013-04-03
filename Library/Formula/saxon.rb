require 'formula'

class Saxon < Formula
  homepage "http://saxon.sourceforge.net"
  url "http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.4/SaxonHE9-4-0-7J.zip"
  sha1 '5a166a7d0c6ae46f664467e6789bf25a5244d225'
  version "9.4.0.7"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'saxon9he.jar', 'saxon'
  end
end
