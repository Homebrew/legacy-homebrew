require 'formula'

class OathToolkit < Formula
  homepage 'http://www.nongnu.org/oath-toolkit/'
  url 'http://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.4.0.tar.gz'
  mirror 'http://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.4.0.tar.gz'
  sha1 '89d2cd30dd401a3f6973ec3c2b26f1cb737764a7'

  depends_on 'pkg-config' => :build
  depends_on 'libxmlsec1'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
