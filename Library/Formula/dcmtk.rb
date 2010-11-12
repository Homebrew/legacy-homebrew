require 'formula'

class Dcmtk <Formula
  homepage 'http://dicom.offis.de/dcmtk.php.en'
  url 'http://dicom.offis.de/download/dcmtk/snapshot/old/dcmtk-3.5.5_20100903.tar.gz'
  md5 '15a8f05a8035bcf7d18ab475b95c9163'
  version '3.5.5_20100903'

  depends_on 'libtiff'

  def install
    ENV.deparallelize
    ENV.m64 if snow_leopard_64?
    ENV.x11
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-threads"
    system "make all"
    system "make install"
  end
end
