require 'formula'

class Tclap < Formula
  homepage 'http://tclap.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/tclap/tclap-1.2.1.tar.gz'
  sha1 '4f124216dd6e6936f5af6372d921a6c51563f8fd'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    # Installer scripts have problems with parallel make
    ENV.deparallelize
    system "make install"
  end
end
