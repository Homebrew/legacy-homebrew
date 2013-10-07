require 'formula'

class Cfitsio < Formula
  homepage 'http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html'
  url 'http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3350.tar.gz'
  sha1 'e928832708d6a5df21a1e17ae4a63036cab7c1b9'
  version '3.350'

  option 'with-examples', "Compile and install example programs"

  resource 'examples' do
    url 'http://heasarc.gsfc.nasa.gov/docs/software/fitsio/cexamples/cexamples.zip'
    version '2012.09.24'
    sha1 '668ffa9a65a66c9f1d7f4241867e1e8adf653231'
  end if build.with? 'examples'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make shared"
    system "make install"

    if build.with? 'examples'
      system "make fpack funpack"
      bin.install 'fpack', 'funpack'

      resource('examples').stage do
        # compressed_fits.c does not work (obsolete function call)
        Dir['*.c'].reject{|f| f == 'compress_fits.c'}.each do |f|
          system ENV.cc, f, "-I#{include}", "-L#{lib}", "-lcfitsio", "-lm", "-o", "#{bin}/#{f.sub('.c', '')}"
        end
      end
    end
  end
end
