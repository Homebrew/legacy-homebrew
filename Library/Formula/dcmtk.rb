require 'formula'

class Dcmtk < Formula
  homepage 'http://dicom.offis.de/dcmtk.php.en'
  url 'ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk360/dcmtk-3.6.0.tar.gz'
  md5 '19409e039e29a330893caea98715390e'

  depends_on 'libtiff'
  depends_on 'doxygen' if ARGV.include? '--install-all'

  def options
    [['--install-all', 'Install development libraries/headers and HTML docs']]
  end

  def install
    ENV.deparallelize
    ENV.m64 if MacOS.prefer_64_bit?
    ENV.x11
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make all"
    if ARGV.include? '--install-all'
      system "make install-all"
    else
      system "make install"
    end
  end
end
