class Dynamips < Formula
  homepage "http://www.gns3.net/dynamips/"
  url "https://github.com/GNS3/dynamips/archive/v0.2.14.tar.gz"
  sha1 "1f0b62d19586365246a957b4eb4dab0cdbd657ad"

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
