require 'formula'

class Grace < Formula
  url 'ftp://plasma-gate.weizmann.ac.il/pub/grace/src/grace5/grace-5.1.22.tar.gz'
  homepage 'http://plasma-gate.weizmann.ac.il/Grace/'
  md5 '672356466f18fe59ed21a8fb44f9851d'

  depends_on 'libpng'
  depends_on 'pdflib-lite'
  depends_on 'jpeg'
  depends_on 'fftw'

  def install
    if File.exists?("/usr/OpenMotif")
      ENV.append 'CFLAGS', "-I/usr/OpenMotif/include"
      ENV.append 'LDFLAGS',"-L/usr/OpenMotif/lib"
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
        "--prefix=#{prefix}", "--with-zlib",
        "--x-includes=/usr/X11/include",
        "--x-libraries=/usr/X11/lib",
        "--with-extra-ldpath=/usr/OpenMotif/lib",
        "--enable-grace-home=#{prefix}"
        system "make install"
    else
      ohnoe "Please install openmotif from http://www.ist-inc.com/downloads/motif_download.html"
    end
  end
end
