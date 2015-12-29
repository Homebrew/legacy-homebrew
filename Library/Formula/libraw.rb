class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "http://www.libraw.org/"
  url "http://www.libraw.org/data/LibRaw-0.17.1.tar.gz"
  sha256 "e599651a4cc37e00cfc2d2b56be87c3a4e4dae2c360b680fe9ab3f93d07cdea1"

  bottle do
    cellar :any
    sha256 "75c29552f6da1d08c81ddc4bd8cd4354f05f73a919fdd7ff2bf92fcd619c9795" => :el_capitan
    sha256 "4257099262c54538daf09f658d1116e645d50862b25180b5bdde1c8db55b5715" => :yosemite
    sha256 "9dba074f9982c8caf7b56d37063f8800f8baa3c8641d7f4cab698404c7d2e8a1" => :mavericks
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
