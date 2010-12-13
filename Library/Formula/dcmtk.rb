require 'formula'

class Dcmtk <Formula
  url 'ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk354/dcmtk-3.5.4.tar.gz'
  homepage 'http://dicom.offis.de/dcmtk.php.en'
  md5 '0afd971cdf976a5b336722ef2f68e6d7'

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
