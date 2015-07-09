class Readosm < Formula
  desc "Extract valid data from an Open Street Map input file"
  homepage "https://www.gaia-gis.it/fossil/readosm/index"
  url "http://www.gaia-gis.it/gaia-sins/readosm-1.0.0e.tar.gz"
  sha256 "1fd839e05b411db6ba1ca6199bf3334ab9425550a58e129c07ad3c6d39299acf"

  bottle do
    cellar :any
    sha1 "048daf9074d277eb64b3d8f479ac3c2cf636d932" => :yosemite
    sha1 "6c6aaf7961bd728538787e3f9b09022d59ad350e" => :mavericks
    sha1 "1f59bbb3b9d0a13d56fc592ae60c67e56f3d9d0d" => :mountain_lion
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
