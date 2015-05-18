class Snapraid < Formula
  homepage "http://snapraid.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/snapraid/snapraid-8.1.tar.gz"
  sha256 "6bf89a1319ac3403958cd2c98a9c6102728c0070cfa1aedd90c4561d93c54e5d"

  head do
    url "https://github.com/amadvance/snapraid.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  bottle do
    cellar :any
    sha256 "5725dceb381a57c2e216cf13f51c0eb68793d772bedaa211ac4de163c23d6a1d" => :yosemite
    sha256 "0fe2f7a73f36103c67b7308f7267be8a37277ed03f8b1573906102c0cf6ed510" => :mavericks
    sha256 "ad68ec9b63b3bc6cc46c2905a57d3b23a5154a94fdf86cfa12a58742c7ec12e3" => :mountain_lion
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
