require 'formula'

class Hidapi < Formula
  homepage 'https://github.com/signal11/hidapi'
  url 'https://github.com/signal11/hidapi.git', :tag => 'hidapi-0.8.0-rc1'
  version '0.8.0-rc1'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build

  def install
    system './bootstrap'
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    (testpath/'test.c').write <<-TEST_SCRIPT.undent
     #include "hidapi.h"
     int main(void)
     {
       return hid_exit();
     }
     TEST_SCRIPT
     flags = `pkg-config --cflags --libs hidapi`.split + ENV.cflags.split
     system ENV.cc, "-o", "test", "test.c", *flags
     system './test'
  end
end
