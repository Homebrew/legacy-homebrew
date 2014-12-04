require "formula"

class Libpointing < Formula
  homepage "http://pointing.org"
  url "http://libpointing.org/libpointing-0.92.tar.gz"
  sha1 "f2206fe87c46d089b8e1db01382aed03080e3a64"

  bottle do
    cellar :any
    sha1 "4eff97b179e5f76dd07e5d2bb17f121580fbdab8" => :yosemite
    sha1 "34a320fcd4ed6a23994e369f28f202b6db9d236a" => :mavericks
    sha1 "5e432b13bba40d68e602da4900bceb7656b23cfa" => :mountain_lion
  end

  depends_on "qt5"

  def install
    system "qmake", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <pointing/input/PointingDevice.h>
      int main() {
        pointing::PointingDevice *device = pointing::PointingDevice::create("any:");
        delete device;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lpointing", "-o", "test"
    system "./test"
  end
end
