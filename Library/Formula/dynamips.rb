class Dynamips < Formula
  desc "Cisco 7200/3600/3725/3745/2600/1700 Router Emulator"
  homepage "https://github.com/GNS3/dynamips"
  url "https://github.com/GNS3/dynamips/archive/v0.2.15.tar.gz"
  sha256 "4f77a88470069dccab391ce786b633061511593efbd0a9b895e5711325eceb36"

  bottle do
    cellar :any_skip_relocation
    sha256 "85c067f77c42527328fe8bf255e9faa6973c04cf1e979948d432333f7f85bd0e" => :el_capitan
    sha256 "3b23d9683f4344d5bbca80bfb4328484e409e215ae7aa4c22c01d5e45217b4f9" => :yosemite
    sha256 "c460f69bc4b30af2d57a7e624bab98ce244b7492d2ef5bd39b24c155708e0625" => :mavericks
    sha256 "c5732f50e1571b3027d3254cce93c29bd6a6e1973a6f9830e02a9fc95721cc46" => :mountain_lion
  end

  depends_on "libelf"
  depends_on "cmake" => :build

  def install
    ENV.append "CFLAGS", "-I#{Formula["libelf"].include}/libelf"

    arch = Hardware.is_64_bit? ? "amd64" : "x86"

    ENV.j1
    system "cmake", ".", "-DANY_COMPILER=1", *std_cmake_args
    system "make", "DYNAMIPS_CODE=stable",
                   "DYNAMIPS_ARCH=#{arch}",
                   "install"
  end

  test do
    system "#{bin}/dynamips", "-e"
  end
end
