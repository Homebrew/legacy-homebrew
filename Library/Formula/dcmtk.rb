require 'formula'

class Dcmtk <Formula
  homepage 'http://dicom.offis.de/dcmtk.php.en'
  url 'http://dicom.offis.de/download/dcmtk/snapshot/old/dcmtk-3.5.5_20101008.tar.gz'
  md5 'd82e7c7910f96a0b27a1a215b752d37e'
  version '3.5.5_20101008'

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
