require 'formula'

class Grace < Formula
  url 'ftp://plasma-gate.weizmann.ac.il/pub/grace/src/grace5/grace-5.1.22.tar.gz'
  homepage 'http://plasma-gate.weizmann.ac.il/Grace/'
  md5 '672356466f18fe59ed21a8fb44f9851d'

  depends_on 'pdflib-lite'
  depends_on 'jpeg'
  depends_on 'fftw'
  depends_on 'lesstif'

  def install
    ENV.x11

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
      "--prefix=#{prefix}", "--with-zlib",
      "--enable-grace-home=#{prefix}"

    system "make install"
  end
end
