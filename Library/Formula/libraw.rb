require 'formula'

class LibrawDemosaicGPL2 < Formula
  url 'http://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.14.5.tar.gz'
  sha1 'ad7e7f090f925a17dc5167c57f051cd090ed17ae'
end

class LibrawDemosaicGPL3 < Formula
  url 'http://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.14.5.tar.gz'
  sha1 '7911e658119e98e3b56203f209fb27b18ec75fd9'
end

class Libraw < Formula
  url 'http://www.libraw.org/data/LibRaw-0.14.5.tar.gz'
  homepage 'http://www.libraw.org/'
  sha1 '5f53787177add7322aa19b926dff34fa28265e16'

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
