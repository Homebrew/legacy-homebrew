class LibdbusmenuQt < Formula
  desc "C++ dbusmenu library for Qt"
  homepage "https://launchpad.net/libdbusmenu-qt"
  url "https://launchpad.net/libdbusmenu-qt/trunk/0.9.2/+download/libdbusmenu-qt-0.9.2.tar.bz2"
  sha256 "ae6c1cb6da3c683aefed39df3e859537a31d80caa04f3023315ff09e5e8919ec"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "qt" => "with-d-bus"
  depends_on "qjson"

  def install
    mkdir "macbuild" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
