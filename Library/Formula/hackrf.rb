class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/mossmann/hackrf"
  url "https://github.com/mossmann/hackrf/archive/v2015.07.2.tar.gz"
  sha256 "00eaca20eceb3f2ed4c23c80353b20dac3a29458b8d33654ff287699d2ed8877"

  bottle do
    cellar :any
    sha256 "c7bdd9df9292a54c7596dbd491f2139c730b34c53292fe1821b8aec7acd64555" => :yosemite
    sha256 "fe5b6d365bce6c478514eb60db4523d16b4fa04c2863d407aa50f7ca4d77833e" => :mavericks
    sha256 "58c43dafc515a6a92b8553fa7a6edea406b02fe44164e60273c882a31bb11496" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    cd "host" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    shell_output("hackrf_transfer", 1)
  end
end
