require 'formula'

class Libvpx <Formula
  head 'git://review.webmproject.org/libvpx.git', :tag => 'v0.9.0'
  homepage 'http://www.webmproject.org/code/'

  depends_on 'yasm'

  def install
    system "./configure"
    system "make"

    include.install Dir["vp8/*.h", "vpx_codec/*.h", "vpx_ports/*.h"]
    lib.install "libvpx.a"
  end
end
