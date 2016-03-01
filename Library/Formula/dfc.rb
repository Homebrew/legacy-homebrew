class Dfc < Formula
  desc "Display graphs and colors of file system space/usage"
  homepage "https://projects.gw-computing.net/projects/dfc"
  url "https://projects.gw-computing.net/attachments/download/467/dfc-3.0.5.tar.gz"
  sha256 "3c947a1d6bc53347b1643921dcbf4c6f8fe7eb6167fc1f4e9436366f036d857a"

  head "https://github.com/Rolinh/dfc.git"

  bottle do
    revision 1
    sha256 "f0d98c80bb3ce8904059831e74ff0cbfede28f61ba50ecf9a4c12e3f1f8875eb" => :el_capitan
    sha256 "1aadc4c37cfe8720c7dccd6e99f67793c1bff8dcea56397913f6c0ce2c5bc0ad" => :yosemite
    sha256 "2f8b4a76d3d7d910229bd68fc30d68cf1289abf1e40fb8fd4c687ae365c6a25d" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "gettext"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"dfc", "-T"
    assert_match ",%USED,", shell_output("#{bin}/dfc -e csv")
  end
end
