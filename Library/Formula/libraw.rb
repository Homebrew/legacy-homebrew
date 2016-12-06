require 'formula'

class LibrawDemosaicGPL2 < Formula
  url 'http://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.13.8.tar.gz'
  sha1 '0a5113d255c292d81ea38f583172ed550518a410'
end

class LibrawDemosaicGPL3 < Formula
  url 'http://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.13.8.tar.gz'
  sha1 'df7bf32567461408c5da74491482a0b700225da4'
end

class Libraw < Formula
  url 'http://www.libraw.org/data/LibRaw-0.13.8.tar.gz'
  homepage 'http://www.libraw.org/'
  sha1 '7b1bc092dc442fd20773c1155e1f3022b379b55a'

  depends_on 'little-cms'

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
        system "#{HOMEBREW_PREFIX}/bin/raw-identify -u #{localraw}"
        system "#{HOMEBREW_PREFIX}/bin/simple_dcraw -v -T #{localraw}"
        system "/usr/bin/qlmanage -p #{localraw}.tiff >& /dev/null &"
        system "/usr/bin/afplay /System/Library/Sounds/Glass.aiff"
        puts "Cheers!"
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
