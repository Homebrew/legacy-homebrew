require 'formula'

class Sam2p < Formula
  url 'http://sam2p.googlecode.com/files/sam2p-0.49.tar.gz'
  homepage 'http://sam2p.googlecode.com'
  md5 '72387e3e3897580fb5ae439713e75177'

  depends_on 'cmake'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-lzw", "--enable-gif"
    system "make install"
  end
end
