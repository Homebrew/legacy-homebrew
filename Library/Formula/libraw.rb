class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "http://www.libraw.org/"
  url "http://www.libraw.org/data/LibRaw-0.17.0.tar.gz"
  sha256 "e643c20945d548aac1eaa1f5573bf74050e0f49ec6a53a6843dc2a2cfb647310"

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
    url "http://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.17.0.tar.gz"
    sha256 "3c5982772f55f0b70c3c7604bc73e8b55f1de7b040e8f144cb220ee88e8bc346"
  end

  resource "gpl3" do
    url "http://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.17.0.tar.gz"
    sha256 "deca57ed524ab4f9915060360d74c5748e6fe8065fd60ca5e969fe9f578a8a0a"
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
