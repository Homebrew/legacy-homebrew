require 'formula'

class Annotate < Formula
  homepage 'http://jeroen.a-eskwadraat.nl/sw/annotate/annotate'
  url 'https://github.com/downloads/msabramo/annotate/annotate-1.2_1.tar.gz'
  md5 '04cde6eaf05dc7ac5d97764f829f22f8'

  def install
    bin.install "annotate"
    man1.install "annotate.1"
  end

  def test
    system "annotate echo -e \"foo\nbar\ndog\""
  end
end
