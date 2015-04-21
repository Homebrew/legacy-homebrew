class Dfc < Formula
  homepage "http://projects.gw-computing.net/projects/dfc"
  url "http://projects.gw-computing.net/attachments/download/467/dfc-3.0.5.tar.gz"
  sha256 "3c947a1d6bc53347b1643921dcbf4c6f8fe7eb6167fc1f4e9436366f036d857a"

  head "https://github.com/Rolinh/dfc.git"

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
