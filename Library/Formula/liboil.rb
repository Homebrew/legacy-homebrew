require 'formula'

class Liboil <Formula
  homepage 'http://liboil.freedesktop.org/'
  url 'http://liboil.freedesktop.org/download/liboil-0.3.17.tar.gz'
  md5 '47dc734f82faeb2964d97771cfd2e701'

  depends_on 'pkg-config'
  depends_on 'glib'

  def install
    arch = Hardware.is_64_bit? ? 'x64_64' : 'i386'
    inreplace "configure", "__HOST_CPU__", "#{arch}"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end

  def patches
    {:p0 => [
      "http://svn.macports.org/repository/macports/trunk/dports/devel/liboil/files/patch-liboil_liboilcpu-x86.c.diff",
      "http://svn.macports.org/repository/macports/trunk/dports/devel/liboil/files/host_cpu.diff"
    ]}
  end
end
