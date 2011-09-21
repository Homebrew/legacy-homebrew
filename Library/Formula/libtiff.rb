require 'formula'

class Libtiff < Formula
  homepage 'http://www.remotesensing.org/libtiff/'
  url 'http://download.osgeo.org/libtiff/tiff-3.9.5.zip'
  sha256 '332d1a658340c41791fce62fb8fff2a5ba04c2e82b8b85e741eb0a7b30e0d127'

  depends_on 'jpeg'  # also deps on system zlib and optional jbigkit

  def options
    [['--with-check', 'Verify the build during install. Takes ~1sec']]
  end

  def install
    ENV.universal_binary  # Builds universal. Default is static & shared.
    bld = `/usr/bin/clang -v 2>&1 | /usr/bin/grep Target`.sub('Target: ', '').chomp
    puts "Your build is #{bld}" if ARGV.verbose?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--build=#{bld}",
                          "--enable-cxx",
                          "--with-apple-opengl-framework"
    system "make"
    system "make check" if ARGV.include? '--with-check'
    system "make install"
  end

  def test
    mktemp do
      aimg = share+'doc/tiff-3.9.5/html/images/bali.jpg'
      bimg = 'temp.gif'
      cimg = 'output.tif'
      j2g = "#{HOMEBREW_PREFIX}/bin/djpeg -gif #{aimg} > #{bimg}"
      g2t = "#{HOMEBREW_PREFIX}/bin/gif2tiff #{bimg} #{cimg}"
      qlt = "/usr/bin/qlmanage -p #{cimg} #{aimg} >& /dev/null"
      lst = "#{HOMEBREW_PREFIX}/bin/tiffinfo #{cimg}"
      puts
      system "#{j2g}"
      system "#{g2t}"
      system "#{qlt}" if ARGV.verbose?
      system "#{lst}" if ARGV.verbose?
      oh1 "Libtiff testing was successful."
      puts
    end
  end
end
