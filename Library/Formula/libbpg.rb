class Libbpg < Formula
  desc "Image format meant to improve on JPEG quality and file size"
  homepage "http://bellard.org/bpg/"
  url "http://bellard.org/bpg/libbpg-0.9.6.tar.gz"
  sha256 "2800777d88a77fd64a4a9036b131f021a5bda8304e1dbe7996dd466567fb484e"

  bottle do
    cellar :any
    revision 1
    sha256 "f5d2349fa1e247411ed624baf5730782fed1e72643cf2e96ce49c4dac50c7764" => :el_capitan
    sha256 "7c4cde5957cfb855aa52edbb3fcf0f489d1803e42060dd8ff7cb042fe84c05f0" => :yosemite
    sha256 "93a4d03c32d1fe837f35a94d9c0f524684ddb29e02a5b507e4817e5b1cddabda" => :mavericks
  end

  option "with-jctvc", "Enable built-in JCTVC encoder - Mono threaded, slower but produce smaller file"
  option "without-x265", "Disable built-in x265 encoder - Multi threaded, faster but produce bigger file"

  depends_on "cmake" => :build
  depends_on "yasm" => :build if build.with? "x265"
  depends_on "libpng"
  depends_on "jpeg"

  def install
    bin.mkpath

    args = []
    args << "USE_JCTVC=y" if build.with? "jctvc"
    args << "USE_X265=" if build.without? "x265"

    system "make", "install", "prefix=#{prefix}", "CONFIG_APPLE=y", *args
  end

  test do
    system "#{bin}/bpgenc", test_fixtures("test.png")
  end
end
