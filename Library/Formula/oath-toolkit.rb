require 'formula'

class OathToolkit < Formula
  homepage 'http://www.nongnu.org/oath-toolkit/'
  url 'http://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.4.1.tar.gz'
  mirror 'http://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.4.1.tar.gz'
  sha1 'b0ca4c5f89c12c550f7227123c2f21f45b2bf969'

  depends_on 'pkg-config' => :build
  depends_on 'libxmlsec1'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
