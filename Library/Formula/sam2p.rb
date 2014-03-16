require 'formula'

class Sam2p < Formula
  homepage 'http://code.google.com/p/sam2p/'
  url 'https://sam2p.googlecode.com/files/sam2p-0.49.2.tar.gz'
  sha1 'a26db7408dfa42ab615d087774128cc5b20ab61d'

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
