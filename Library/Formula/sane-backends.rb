require 'formula'

class SaneBackends <Formula
  url 'ftp://ftp.sane-project.org/pub/sane/sane-backends-1.0.20/sane-backends-1.0.20.tar.gz'
  homepage 'http://www.sane-project.org/'
  md5 'a0cfdfdebca2feb4f2ba5d3418b15a42'

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
