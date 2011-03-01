require 'formula'

class Dcmtk <Formula
  homepage 'http://dicom.offis.de/dcmtk.php.en'
  url 'ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk360/dcmtk-3.6.0.tar.gz'
  md5 '19409e039e29a330893caea98715390e'
  version '3.6.0'

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
