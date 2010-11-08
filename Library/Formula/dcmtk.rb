require 'formula'

class Dcmtk <Formula
  url 'http://dicom.offis.de/download/dcmtk/snapshot/old/dcmtk-3.5.5_20100903.tar.gz'
  homepage 'http://dicom.offis.de/dcmtk.php.en'
  md5 '15a8f05a8035bcf7d18ab475b95c9163'
  version "3.5.5.20100903"

  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'libtiff'
  depends_on 'libxml2'

  def install
    ENV.deparallelize
    ENV.m64 if snow_leopard_64?

    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-threads",
                          "--with-libtiffinc",
                          "--with-libpnginc",
                          "--with-libxmlinc"
    system "make all"
    system "make install"
  end
end
