class Dynamips < Formula
  desc "Cisco 7200/3600/3725/3745/2600/1700 Router Emulator"
  homepage "http://www.gns3.net/dynamips/"
  url "https://github.com/GNS3/dynamips/archive/v0.2.14.tar.gz"
  sha1 "1f0b62d19586365246a957b4eb4dab0cdbd657ad"

  bottle do
    cellar :any
    sha1 "d0d6ed53cac613224298052a4403f215d41cdeaa" => :yosemite
    sha1 "bdcd75d6bfd8800340620f934193ac952e9ee455" => :mavericks
    sha1 "14bf80d8127981a9fab5e8cb94fd1c771a0cbe4c" => :mountain_lion
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
