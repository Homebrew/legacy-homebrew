require "formula"

class Ttylog < Formula
  homepage "http://ttylog.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ttylog/ttylog/0.25/ttylog-0.25.tar.gz"
  sha1 "02bb49066d861690439b351f06b0c3bdb203f06b"

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
      system "make install"

      bin.install sbin/"ttylog"
    end
  end

  test do
    system "#{bin}/ttylog", "-h"
  end
end
