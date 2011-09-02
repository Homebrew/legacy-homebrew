require 'formula'

class Sam2p < Formula
  url 'http://sam2p.googlecode.com/files/sam2p-0.49.tar.gz'
  homepage 'http://code.google.com/p/sam2p/'
  md5 '72387e3e3897580fb5ae439713e75177'

  def install
    system "./configure", "--enable-lzw", "--enable-gif",
                          "--prefix=#{prefix}"
    system "make"

    bin.install "sam2p"
    bin.install "sam2p_pdf_scale.pl"
  end
end
