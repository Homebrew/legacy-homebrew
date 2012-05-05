require 'formula'

class LibrawDemosaicGPL2 < Formula
  url 'http://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.14.6.tar.gz'
  sha1 'cde9b65ba48b6111353964127532d2d2203edb9a'
end

class LibrawDemosaicGPL3 < Formula
  url 'http://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.14.6.tar.gz'
  sha1 'b89bb2f44dbd42c0aa2a4fee2c6c7bb2a73d6dac'
end

class Libraw < Formula
  homepage 'http://www.libraw.org/'
  url 'http://www.libraw.org/data/LibRaw-0.14.6.tar.gz'
  sha1 '0a55901d17165cc7e902af9c376df9bab4c40833'

  depends_on 'little-cms2'

  def install
    d = Pathname.getwd.dirname
    LibrawDemosaicGPL2.new.brew { d.install Dir['*'] }
    LibrawDemosaicGPL3.new.brew { d.install Dir['*'] }

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-demosaic-pack-gpl2=#{d}",
                          "--enable-demosaic-pack-gpl3=#{d}"
    system "make"
    system "make install"
    doc.install Dir['doc/*']
    (prefix+'samples').mkpath
    (prefix+'samples').install Dir['samples/*']
  end

  def test
    mktemp do
      netraw = "http://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF"
      localraw = "#{HOMEBREW_CACHE}/Formula/RAW_NIKON_D1.NEF"
      if File.exists? localraw
        system "#{bin}/raw-identify -u #{localraw}"
        system "#{bin}/simple_dcraw -v -T #{localraw}"
        system "/usr/bin/qlmanage -p #{localraw}.tiff >& /dev/null &"
      else
        puts ""
        opoo <<-EOS.undent
          A good test that uses libraw.dylib to open and convert a RAW image
          to tiff was delayed until the RAW test image from the Internet is in your
          cache. To download that image and run the test, simply type

             brew fetch #{netraw}
             brew test libraw

          It's a fairly small image, 4 MB, that takes less time to download than
          read this.  Please ignore the harmless message from brew fetch about
          No Available Formula.  Brew fetch works correctly as does this well
          written software.

        EOS
      end
    end
  end
end
