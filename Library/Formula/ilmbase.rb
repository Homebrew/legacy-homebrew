class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "http://www.openexr.com/"
  url "https://savannah.nongnu.org/download/openexr/ilmbase-2.2.0.tar.gz"
  mirror "https://mirrorservice.org/sites/download.savannah.gnu.org/releases/openexr/ilmbase-2.2.0.tar.gz"
  sha256 "ecf815b60695555c1fbc73679e84c7c9902f4e8faa6e8000d2f905b8b86cedc7"

  bottle do
    revision 1
    sha256 "1d4bcd7e058e1b629bcd608d063d64266253e2e671084c2f54df69061b1bd439" => :el_capitan
    sha256 "c660a7b84cf84a03a17c3bf5cd1b86dd1e0357cb9e2d854665f4d538786c8014" => :yosemite
    sha256 "db95cf0582acc259b987fe194eb50cc760b25d733b9ff195c25448e21e21e039" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
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
