class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  url "https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
  sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"
  revision 1

  bottle do
    sha256 "d04f2f46eaa9b3fa1d6e67e0493e8b206f873c6211874962b8ef06865bbf5c71" => :yosemite
    sha256 "59a4e155666ed1854a2b38204d750ddc0af75ebd988367b1629be4a9f00a6c1f" => :mavericks
    sha256 "84aaaa696f7ea8837d13a3a1e58d826978be781c01dd5a77fa20197f45b7d25b" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "libtiff"
  depends_on "ilmbase"
  depends_on "openexr"
  depends_on "aces_container"

  def install
    ENV.delete "CTL_MODULE_PATH"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end

  test do
    assert_match /transforms an image/, shell_output("#{bin}/ctlrender -help", 1)
  end
end
