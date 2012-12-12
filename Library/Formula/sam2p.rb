require 'formula'

class Sam2p < Formula
  homepage 'http://code.google.com/p/sam2p/'
  url 'http://sam2p.googlecode.com/files/sam2p-0.49.1.tar.gz'
  sha1 '5922e6029e2ed4e524066080476e02ddfdbcc18e'

  fails_with :clang do
    build 421
    cause "treating 'c' input as 'c++' when in C++ mode, this behavior is deprecated"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-lzw",
                          "--enable-gif"
    system "make"

    bin.install "sam2p"
    bin.install "sam2p_pdf_scale.pl"
  end
end
