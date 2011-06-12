require 'formula'

class Libgsm < Formula
  url 'http://www.quut.com/gsm/gsm-1.0.13.tar.gz'
  homepage 'http://packages.qa.debian.org/libg/libgsm.html'
  md5 'c1ba392ce61dc4aff1c29ea4e92f6df4'

  def install
    system "make"
#    system "make", "INSTALL_ROOT=#{prefix}",
#                   "GSM_INSTALL_LIB=#{lib}",
#                   "GSM_INSTALL_INC=#{include}/gsm",
#                   "GSM_INSTALL_MAN=#{man}",
#                   "TOAST_INSTALL_MAN=#{man}",
#                   "install"
    bin.install Dir['bin/*']
    lib.install Dir['lib/*']
    (include+'gsm').install Dir['inc/*']
    man1.install Dir['man/*.1']
    man3.install Dir['man/*.3']
  end
end
