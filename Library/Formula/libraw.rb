class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "http://www.libraw.org/"
  url "http://www.libraw.org/data/LibRaw-0.16.0.tar.gz"
  sha256 "71f43871ec2535345c5c9b748f07813e49915170f9510b721a2be6478426cf96"

  bottle do
    cellar :any
    sha1 "49b78411b56fbf825d5170fadb9e81cc0473ab11" => :yosemite
    sha1 "af54b03cb2b500969ede436f0c15e282b89e8968" => :mavericks
    sha1 "d527170bd8c1e2bc8b0d755ba69938c4f0cec335" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "jasper"
  depends_on "little-cms2"

  resource "librawtestfile" do
    url "http://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF",
      :using => :nounzip
    sha256 "7886d8b0e1257897faa7404b98fe1086ee2d95606531b6285aed83a0939b768f"
  end

  resource "gpl2" do
    url "http://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.16.0.tar.gz"
    sha256 "749d49694ce729166ec7a1faf7580780687ef190c756931bb075455ee8ed6697"
  end

  resource "gpl3" do
    url "http://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.16.0.tar.gz"
    sha256 "f2e904f9baa7d173b5ade163c795f26e110255a758e31bd213086a5a61500b5c"
  end

  def install
    %w[gpl2 gpl3].each { |f| (buildpath/f).install resource(f) }
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
