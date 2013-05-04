require 'formula'

class OathToolkit < Formula
  homepage 'http://www.nongnu.org/oath-toolkit/'
  url 'http://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.0.2.tar.gz'
  mirror 'http://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.0.2.tar.gz'
  sha1 '3672924a9d9c3373ec62a6b79e9aa1e846c4d178'

  depends_on 'pkg-config' => :build
  depends_on 'libxmlsec1'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
