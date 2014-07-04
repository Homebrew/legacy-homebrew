require 'formula'

class Libraw < Formula
  homepage 'http://www.libraw.org/'
  url 'http://www.libraw.org/data/LibRaw-0.15.4.tar.gz'
  sha1 '1561e1ac12df6eed999d5be3146d66176c050b76'

  bottle do
    cellar :any
    sha1 "e9f82236c16db31ce392eba28bc8cdcfb7e36dc0" => :mavericks
    sha1 "6576ac9a95edfd4e13397a043a2ae1059519da97" => :mountain_lion
    sha1 "addbaf9c45f13e9a2732b81bc2d8ad960908cf2d" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'jasper'
  depends_on 'little-cms2'

  resource 'librawtestfile' do
    url 'http://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF',
      :using => :nounzip
    sha1 'd84d47caeb8275576b1c7c4550263de21855cf42'
  end

  resource 'gpl2' do
    url 'http://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.15.4.tar.gz'
    sha1 '9eaa33b53e15053937a1ac081227713cae7f25fb'
  end

  resource 'gpl3' do
    url 'http://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.15.4.tar.gz'
    sha1 'd9ce308bccae75f26fa56ab6c2ad705ef0eaa761'
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

  test do
    resource('librawtestfile').stage do
      filename = 'RAW_NIKON_D1.NEF'
      system "#{bin}/raw-identify", "-u", filename
      system "#{bin}/simple_dcraw", "-v", "-T", filename
    end
  end
end
