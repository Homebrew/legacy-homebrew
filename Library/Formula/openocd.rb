require 'formula'

class Openocd <Formula
  url 'http://download.berlios.de/openocd/openocd-0.4.0.tar.bz2'
  homepage 'http://openocd.berlios.de/web/'
  md5 '11a81b5f200fb0c318d9f49182bb71d7'

 depends_on 'libftdi'

  def install
    ENV.append "CFLAGS", "-I/usr/local/include/libftdi" 
    system "./configure", "--disable-debug", "--enable-ft2232_libftdi", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
