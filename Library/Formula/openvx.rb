class Openvx < Formula
  homepage "https://www.khronos.org/openvx/"
  url "https://www.khronos.org/registry/vx/sample/openvx_sample_20141217.tar.gz"
  sha1 "144403e3b3e7e7f6f3a75371bfd3ca023466bbfa"
  version "1.0" # Official version this snapshot implements

  depends_on "cmake" => :build

  patch do
    url "https://raw.githubusercontent.com/invx/homebrew-openvx/master/openvx_sample_macos.diff"
    sha1 "3e5db79d4218c9cdf46e993f0f076ac4ee06495c"
  end

  # TODO: add flags for OpenCL support and SDL demo/libs

  def install
    args = std_cmake_args
    args << "-DAPPLE=1"
    args << "-DBUILD_X64=1"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    # TODO: ideally this should be vx_test - which runs but needs the test
    # images to also be installed, and locatable, for it...
    system "vx_example"
  end

end
