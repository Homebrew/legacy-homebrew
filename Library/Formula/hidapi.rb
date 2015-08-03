class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/signal11/hidapi"
  url "https://github.com/signal11/hidapi/archive/hidapi-0.8.0-rc1.tar.gz"
  sha256 "3c147200bf48a04c1e927cd81589c5ddceff61e6dac137a605f6ac9793f4af61"

  # This patch addresses a bug discovered in the HidApi IOHidManager back-end
  # that is being used with Macs.
  # The bug was dramatically changing the behaviour of the function
  # "hid_get_feature_report". As a consequence, many applications working
  # with HidApi were not behaving correctly on OSX.
  # pull request on Hidapi's repo: https://github.com/signal11/hidapi/pull/219
  patch do
    url "https://patch-diff.githubusercontent.com/raw/signal11/hidapi/pull/219.diff"
    sha256 "82631c8a6ec307482c09c133f9da89672c781665704304aa0ef286467b7fe5c2"
  end

  bottle do
    cellar :any
    revision 1
    sha256 "7fb4f99e0d29846541d91834a85c993b4391f78e5635d154da3ef025b0f84be3" => :yosemite
    sha256 "28c0f7b67d8d041f70f2e7278f0e216660c5b4f004d6330f741485e8d75a4955" => :mavericks
    sha256 "b7ced91d5e87d1d47ffc12de47ffbeac3391f1070fb0e2b47b84c929f372e99e" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "hidapi.h"
      int main(void)
      {
        return hid_exit();
      }
    EOS

    flags = ["-I#{include}/hidapi", "-L#{lib}", "-lhidapi"] + ENV.cflags.to_s.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
