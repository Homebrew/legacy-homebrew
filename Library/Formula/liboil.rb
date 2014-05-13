require 'formula'

class Liboil < Formula
  homepage 'http://liboil.freedesktop.org/'
  url 'http://liboil.freedesktop.org/download/liboil-0.3.17.tar.gz'
  sha1 'f9d7103a3a4a4089f56197f81871ae9129d229ed'

  depends_on 'pkg-config' => :build

  patch :p0 do
    url "https://trac.macports.org/export/89276/trunk/dports/devel/liboil/files/patch-liboil_liboilcpu-x86.c.diff"
    sha1 "6e5043b0f493533a824ea251296e8a8d390a3eb5"
  end

  patch :p0 do
    url "https://trac.macports.org/export/89276/trunk/dports/devel/liboil/files/host_cpu.diff"
    sha1 "08a0021cca90be8394d7ed5fe0e61d6f25618193"
  end

  def install
    arch = Hardware.is_64_bit? ? 'x64_64' : 'i386'
    inreplace "configure", "__HOST_CPU__", arch
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <liboil/liboil.h>
      int main(int argc, char** argv) {
        oil_init();
        return 0;
      }
    EOS
    flags = `#{HOMEBREW_PREFIX}/bin/pkg-config --cflags --libs liboil-0.3`.split + ENV.cflags.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end

end
