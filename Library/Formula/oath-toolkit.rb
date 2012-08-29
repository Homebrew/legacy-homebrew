require 'formula'

class OathToolkit < Formula
  homepage 'http://www.nongnu.org/oath-toolkit/'
  url 'http://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-1.12.0.tar.gz'
  mirror 'http://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-1.12.0.tar.gz'
  sha1 'd839ed4748220fc77cc80743816b48cef1a75f5b'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
