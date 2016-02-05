class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://downloads.openfabrics.org/downloads/ofi/libfabric-1.2.0.tar.bz2"
  sha256 "179da0e27b47ca35b5ec823c30cdcc63cf991f0f86bfd655e091a1268d1a3182"

  bottle do
    sha256 "fb5c566ee556d050f53f19568f752cb5bab989ef01198eddd1b64df26cbdbcdc" => :el_capitan
    sha256 "34ad02c68e5d921bcf0e0d5086aeb0cbb39157353bbc7dba4cf03d3e4fcbb748" => :yosemite
    sha256 "e3f95c8408b8b0ec925c65c812a4f1aec3206b1363dfe8fb85d886c099b7b6cd" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#(bin}/fi_info"
  end
end
