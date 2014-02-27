require 'formula'

class Xclip < Formula
  homepage 'http://xclip.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/xclip/xclip/0.12/xclip-0.12.tar.gz'
  sha1 'aed2cff18b9aecfe3377ad064c6a67518bbec211'

  depends_on :x11

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/xclip", "-version"
  end
end
