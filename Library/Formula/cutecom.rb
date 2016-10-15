class Cutecom < Formula
  homepage "http://cutecom.sourceforge.net"
  url "http://cutecom.sourceforge.net/cutecom-0.22.0.tar.gz"
  version "0.22.0"
  sha1 "a23f9ddf3d1a4467568c872477fc8c6da07c1711"

  depends_on "cmake" => :build
  depends_on "qt" => ["with-qt3support"]

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "ls", "/Applications/CuteCom.app"
  end
end
