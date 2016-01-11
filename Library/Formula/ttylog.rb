class Ttylog < Formula
  desc "Serial port logger: print everything from a serial device"
  homepage "http://ttylog.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ttylog/ttylog/0.25/ttylog-0.25.tar.gz"
  sha256 "80d0134ae4e29b650fff661169a6e667d22338465720ee768b2776f68aac8614"

  bottle do
    cellar :any
    sha256 "b424c6473bcd948c8ef60d81d9cf0e176cd77189a54d08e480ad2c2f33692364" => :mavericks
    sha256 "5a0e421f1735316419f1620227a9e76d89160bb79e3e2463e6ea89145cd3f398" => :mountain_lion
    sha256 "076970af724989d93fc7eb4eee008a8320eb5a6e09e3517f55dca7841bfced12" => :lion
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
