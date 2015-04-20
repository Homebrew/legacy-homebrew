require 'formula'

class Mpegdemux < Formula
  homepage 'http://www.hampa.ch/mpegdemux/'
  url 'http://www.hampa.ch/mpegdemux/mpegdemux-0.1.4.tar.gz'
  sha1 '1778304fbe6f8be4d25034d1b6a8acef6c91e311'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/mpegdemux", "--help"
  end
end
