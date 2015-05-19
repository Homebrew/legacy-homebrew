class Libechonest < Formula
  desc "Qt library for communicating with The Echo Nest"
  homepage "https://projects.kde.org/projects/playground/libs/libechonest"
  url "http://files.lfranchi.com/libechonest-2.3.1.tar.bz2"
  sha256 "56756545fd1cb3d9067479f52215b6157c1ced2bc82b895e72fdcd9bebb47889"

  bottle do
    cellar :any
    sha256 "155a7921bd0e807a5702d9cf2f85b0fa2636713c57ee2c355cf27b70bd567c79" => :yosemite
    sha256 "0e774fa6901a1d8c7244e8fcbbaefdd2a1b4f1d69d9ab3061c9dd67d468ac57b" => :mavericks
    sha256 "093d7b8f68f0ef72da44b8118d96a0e103f37788e91294006fb1fd09fbe04d82" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "qjson"

  conflicts_with "doxygen", :because => "cmake fails to configure build."

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <echonest/Genre.h>
      #include <echonest/Artist.h>
      int main() {
        Echonest::Genre test;
        test.setName(QLatin1String("ambient trance"));
        return 0;
      }
    EOS
    qt = Formula["qt"]
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lechonest", "-F#{qt.opt_lib}",
      "-framework", "QtCore", "-I#{qt.opt_include}/QtCore",
      "-I#{qt.opt_include}/QtNetwork", "-o", "test"
    system "./test"
  end
end
