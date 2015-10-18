class Sam2p < Formula
  desc "Convert raster images to EPS, PDF, and other formats"
  homepage "https://code.google.com/p/sam2p/"
  url "https://sam2p.googlecode.com/files/sam2p-0.49.2.tar.gz"
  sha256 "0e75d94bed380f8d8bd629f7797a0ca533b5d0b40eba2dab339146dedc1f79bf"

  fails_with :clang do
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
