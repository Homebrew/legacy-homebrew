class Ttylog < Formula
  desc "Serial port logger: print everything from a serial device"
  homepage "http://ttylog.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ttylog/ttylog/0.25/ttylog-0.25.tar.gz"
  sha256 "80d0134ae4e29b650fff661169a6e667d22338465720ee768b2776f68aac8614"

  bottle do
    cellar :any
    sha1 "5c8e70c0b3a1ad9b5708aa4bcb2fed311d24ead3" => :mavericks
    sha1 "f5e83d8be3255cede1df0c55f51bfc2bfc4533ff" => :mountain_lion
    sha1 "5a003888636ca2b2bd252d7f65602a2ac86f540c" => :lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"

      bin.install sbin/"ttylog"
    end
  end

  test do
    system "#{bin}/ttylog", "-h"
  end
end
