require 'formula'

class Spiped < Formula
  homepage 'http://www.tarsnap.com/spiped.html'
  url 'https://www.tarsnap.com/spiped/spiped-1.2.2.tgz'
  sha256 'a9eb4681e4ccd5d86b8a2d4e16785db8ba10d8a9f7f732485511fd4b92dff1ec'

  depends_on :bsdmake

  def install
    system "bsdmake", "BINDIR_DEFAULT=#{bin}", "install"
    doc.install 'spiped/README' => 'README.spiped',
                'spipe/README' => 'README.spipe'
  end
end
