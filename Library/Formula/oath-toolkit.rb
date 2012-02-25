require 'formula'

class OathToolkit < Formula
  homepage 'http://www.nongnu.org/oath-toolkit/'
  url 'http://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-1.10.5.tar.gz'
  mirror 'http://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-1.10.5.tar.gz'
  sha1 'b3fddfbc442c7cffe854ec159466155ef6ce0cbc'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--without-pam"
    system "make"
    system "make install"
  end
end
