require 'formula'

class LibrawTestFile < Formula
  url 'http://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF',
    :using => :nounzip
  sha1 'd84d47caeb8275576b1c7c4550263de21855cf42'
end

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
    d = buildpath.dirname
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
    LibrawTestFile.new.brew do
      filename = 'RAW_NIKON_D1.NEF'
      system "#{bin}/raw-identify", "-u", filename
      system "#{bin}/simple_dcraw", "-v", "-T", filename
      system "/usr/bin/qlmanage", "-p", "#{filename}.tiff"
    end
  end
end
