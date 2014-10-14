require 'formula'

class Grace < Formula
  homepage 'http://plasma-gate.weizmann.ac.il/Grace/'
  url 'ftp://plasma-gate.weizmann.ac.il/pub/grace/src/grace5/grace-5.1.23.tar.gz'
  sha1 '0bd9cd6e76c97210658098f3533b5cf6c037d0bd'

  depends_on :x11
  depends_on 'pdflib-lite'
  depends_on 'jpeg'
  depends_on 'fftw'
  depends_on 'lesstif'

  def install
    ENV.O1 # https://github.com/Homebrew/homebrew/issues/27840#issuecomment-38536704
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-grace-home=#{prefix}"

    system "make install"
  end
end
