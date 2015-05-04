class Openexr < Formula
  homepage "http://www.openexr.com/"
  url "http://download.savannah.nongnu.org/releases/openexr/openexr-2.2.0.tar.gz"
  sha256 "36a012f6c43213f840ce29a8b182700f6cf6b214bea0d5735594136b44914231"

  bottle do
    cellar :any
    revision 1
    sha1 "be055103cf96edbd87f01d200ae97365a13dfd33" => :yosemite
    sha1 "5263df7bfe3a4a6c5e8c21aaa9d1a49cad666e3d" => :mavericks
    sha1 "f32df24d8a0c74d0b8e53b9e0e15d60dceaf0b6a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
