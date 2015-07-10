class Readosm < Formula
  desc "Extract valid data from an Open Street Map input file"
  homepage "https://www.gaia-gis.it/fossil/readosm/index"
  url "https://www.gaia-gis.it/gaia-sins/readosm-1.0.0e.tar.gz"
  sha256 "1fd839e05b411db6ba1ca6199bf3334ab9425550a58e129c07ad3c6d39299acf"

  bottle do
    sha256 "4449dcac0910846c27c4c5b3fe68b7aa5505132835f1de07d27551eb7f9becd9" => :yosemite
    sha256 "ab9b88f09f4debd36b0618700952344f38921937855f14937727cac8c2ff9af8" => :mavericks
    sha256 "a73c751faf283779d13ae63350248e2207ca399a33ec87a753153415f3f52de3" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lreadosm",
           doc/"examples/test_osm1.c", "-o", testpath/"test"
    assert_equal "usage: test_osm1 path-to-OSM-file",
                 shell_output("./test 2>&1", 255).chomp
  end
end
