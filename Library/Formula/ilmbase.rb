class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "http://www.openexr.com/"
  url "http://download.savannah.nongnu.org/releases/openexr/ilmbase-2.2.0.tar.gz"
  mirror "http://download-mirror.savannah.gnu.org/releases/openexr/ilmbase-2.2.0.tar.gz"
  sha256 "ecf815b60695555c1fbc73679e84c7c9902f4e8faa6e8000d2f905b8b86cedc7"

  bottle do
    sha256 "8731825e3d23b3039f73cbe803dcd6dc5af6df5ae14f59dbc9c51c83d1777c04" => :yosemite
    sha256 "a944b3ec5ff894f4dc236f278e3ee24820b47247858c4f5a6c2480cd5855ce9d" => :mavericks
    sha256 "004459343b047ccf6e8474c37df3f20fa01d6093d68edf11aa56b11c80a4e617" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    (share/"ilmbase").install %W[Half HalfTest Iex IexMath IexTest IlmThread Imath ImathTest]
  end

  test do
    cd share/"ilmbase/IexTest" do
      system ENV.cxx, "-I#{include}/OpenEXR", "-I./", "-c",
             "testBaseExc.cpp", "-o", testpath/"test"
    end
  end
end
