require 'formula'

class CfitsioExamples < Formula
  url 'http://heasarc.gsfc.nasa.gov/docs/software/fitsio/cexamples/cexamples.zip'
  md5 '31a5f5622a111f25bee5a3fda2fdac28'
  version '2010.08.19'
end

class Cfitsio < Formula
  url 'ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3290.tar.gz'
  homepage 'http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html'
  md5 'd0d460c5e314a15fa6905b2096159827'
  version '3.29'

  def options
    [
     ['--with-examples', "Compile and install example programs from http://heasarc.gsfc.nasa.gov/docs/software/fitsio/cexamples.html as well as fpack and funpack"]
    ]
  end

  def install
    # --disable-debug and --disable-dependency-tracking are not recognized by configure
    system "./configure", "--prefix=#{prefix}"
    system "make shared"
    system "make install"

    if ARGV.include? '--with-examples'
      system "make fpack funpack"
      bin.install ['fpack', 'funpack']

      # fetch, compile and install examples programs
      CfitsioExamples.new.brew do
        mkdir 'bin'
        Dir.glob('*.c').each do |f|
          # compressed_fits.c does not work (obsolete function call)
          if f != 'compress_fits.c'
            system "#{ENV.cc} #{f} -I#{include} -L#{lib} -lcfitsio -lm -o bin/#{f.sub('.c','')}"
          end
        end
        bin.install Dir['bin/*']
      end
    end
  end
end
