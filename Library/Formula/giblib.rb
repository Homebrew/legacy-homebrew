require 'formula'

class Giblib < Formula
  homepage 'http://freshmeat.net/projects/giblib'
  url 'http://linuxbrit.co.uk/downloads/giblib-1.2.4.tar.gz'
  mirror 'http://www.mirrorservice.org/sites/distfiles.macports.org/giblib/giblib-1.2.4.tar.gz'
  sha1 '342e6f7882c67d2277e1765299e1be5078329ab0'

  bottle do
    cellar :any
    sha1 "faa1b6df15695d6e2122df29fa332733aba2d954" => :mavericks
    sha1 "6c95c35b66fec113ccc39e9fadfd5bf6ba421a5a" => :mountain_lion
    sha1 "00a28fdd58b727141b6b5b2b8856d805e027a01c" => :lion
  end

  depends_on :x11
  depends_on 'imlib2' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/giblib-config", "--version"
  end
end
