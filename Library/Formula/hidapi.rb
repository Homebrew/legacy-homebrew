require 'formula'

class Hidapi < Formula
  homepage 'https://github.com/signal11/hidapi'
  url 'https://github.com/signal11/hidapi/archive/hidapi-0.8.0-rc1.tar.gz'
  sha1 '5e72a4c7add8b85c8abcdd360ab8b1e1421da468'

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
    (testpath/'test.c').write <<-EOS.undent
      #include "hidapi.h"
      int main(void)
      {
        return hid_exit();
      }
    EOS

    flags = `pkg-config --cflags --libs hidapi`.split + ENV.cflags.to_s.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system './test'
  end
end
