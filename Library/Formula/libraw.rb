require 'formula'

class LibrawTestFile < Formula
  url 'http://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF',
    :using => :nounzip
  sha1 'd84d47caeb8275576b1c7c4550263de21855cf42'
end

class Libraw < Formula
  homepage 'http://www.libraw.org/'
  url 'http://www.libraw.org/data/LibRaw-0.14.7.tar.gz'
  sha1 'e924527bed3d72ee4756da0c9383dc74c584799f'

  depends_on 'pkg-config' => :build
  depends_on 'jasper'
  depends_on 'little-cms2'

  resource 'gpl2' do
    url 'http://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.14.7.tar.gz'
    sha1 '9a95d5be316c6efe91228ab696eb39c565922cad'
  end

  resource 'gpl3' do
    url 'http://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.14.7.tar.gz'
    sha1 '63b1e4899c7aa1a9023e6f4516b91c9c9aa3893e'
  end

  def install
    %w(gpl2 gpl3).each {|f| (buildpath/f).install resource(f)}
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-demosaic-pack-gpl2=#{buildpath}/gpl2",
                          "--enable-demosaic-pack-gpl3=#{buildpath}/gpl3"
    system "make"
    system "make install"
    doc.install Dir['doc/*']
    prefix.install 'samples'
  end

  def test
    LibrawTestFile.new.brew do
      filename = 'RAW_NIKON_D1.NEF'
      system "#{bin}/raw-identify", "-u", filename
      system "#{bin}/simple_dcraw", "-v", "-T", filename
    end
  end
end
