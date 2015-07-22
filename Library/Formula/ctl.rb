class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  url "https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
  sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"
  revision 1

  bottle do
    sha256 "860d6ce8218cf26830ac61327c45d862df1dd33b58996278d37341b34c8062e6" => :yosemite
    sha256 "ed30b61d129d781b395fde6b0d925ad01d6bd5f64220c54c04d7971b20ae9663" => :mavericks
    sha256 "ff805ef59d8958823c8eab7b0dab86eddc923d37493874ac4b6ec2908f1b348b" => :mountain_lion
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
