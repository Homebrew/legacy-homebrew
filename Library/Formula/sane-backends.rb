require 'formula'

class SaneBackends <Formula
  url 'ftp://ftp.sane-project.org/pub/sane/sane-backends-1.0.22/sane-backends-1.0.22.tar.gz'
  homepage 'http://www.sane-project.org/'
  md5 'fadf56a60f4776bfb24491f66b617cf5'

  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--enable-libusb",
                          "--disable-latex"
    system "make"
    system "make install"
  end
end
