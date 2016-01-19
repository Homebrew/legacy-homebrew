class Openexr < Formula
  desc "OpenEXR Graphics Tools (high dynamic-range image file format)"
  homepage "http://www.openexr.com/"
  url "http://download.savannah.nongnu.org/releases/openexr/openexr-2.2.0.tar.gz"
  sha256 "36a012f6c43213f840ce29a8b182700f6cf6b214bea0d5735594136b44914231"

  bottle do
    cellar :any
    sha256 "ae31cedab570d5840d584964967e348ca3daab63541a92d32adef434fb1757f6" => :el_capitan
    sha256 "5bdf90ede738749524f2ed6504fe833cb99771dc2517f3546558efa0512525c1" => :yosemite
    sha256 "cafdc8251501bd6a0dc3bbf919469872498c1a378f7f21809614498c968e3e49" => :mavericks
    sha256 "9fad65fc10a89ee39bda6e89c6f0f84828c867105a50c16f7bd03dc2c5476c86" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  # Fixes builds on 32-bit targets due to incorrect long literals
  # Patches are already applied in the upstream git repo.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/f1a3ea4f69b7a54d8123e2f16488864d52202de8/openexr/64bit_types.patch"
    sha256 "c95374d8fdcc41ddc2f7c5b3c6f295a56dd5a6249bc26d0829548e70f5bd2dc9"
  end

  def install
    ENV.universal_binary if build.universal?
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
