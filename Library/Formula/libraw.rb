class Libraw < Formula
  homepage "http://www.libraw.org/"
  url "http://www.libraw.org/data/LibRaw-0.16.0.tar.gz"
  sha1 "492239aa209b1ddd1f030da4fc2978498c32a29b"

  bottle do
    cellar :any
    revision 1
    sha1 "7f451901d85f31ae94f315a9c89eb42660fdd61b" => :yosemite
    sha1 "2343787be91bcb214f3806a38c1539ef8ee06ada" => :mavericks
    sha1 "303ab92ea058626cf446efb4f0d2833b83ebe4f9" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "jasper"
  depends_on "little-cms2"

  resource "librawtestfile" do
    url "http://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF",
      :using => :nounzip
    sha1 "d84d47caeb8275576b1c7c4550263de21855cf42"
  end

  resource "gpl2" do
    url "http://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.16.0.tar.gz"
    sha1 "af4959b111e8cd927c3a23cca5ad697521fae3d2"
  end

  resource "gpl3" do
    url "http://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.16.0.tar.gz"
    sha1 "8a709ae35e7a040b78ffb6b9d21faab25f7146cb"
  end

  def install
    %w(gpl2 gpl3).each {|f| (buildpath/f).install resource(f)}
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-demosaic-pack-gpl2=#{buildpath}/gpl2",
                          "--enable-demosaic-pack-gpl3=#{buildpath}/gpl3"
    system "make"
    system "make", "install"
    doc.install Dir["doc/*"]
    prefix.install "samples"
  end

  test do
    resource("librawtestfile").stage do
      filename = "RAW_NIKON_D1.NEF"
      system "#{bin}/raw-identify", "-u", filename
      system "#{bin}/simple_dcraw", "-v", "-T", filename
    end
  end
end
