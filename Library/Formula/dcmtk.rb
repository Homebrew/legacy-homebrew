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

    args = [
      "--prefix=#{prefix}",
      "--disable-threads",
      "--disable-debug",
      "--mandir=#{man}",
      "--disable-dependency-tracking",
      "--with-libtiffinc",
      "--with-libpnginc",
      "--with-libxmlinc"
    ]

    if snow_leopard_64?
      args << "CXXFLAGS=-m64"
      args << "CFLAGS=-m64"
    end

    system "./configure", *args

    system "make all"
    system "make install"
  end
end
