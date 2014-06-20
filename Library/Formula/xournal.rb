require 'formula'

class Xournal < Formula
  homepage 'http://xournal.sourceforge.net'
  url 'https://downloads.sourceforge.net/xournal/xournal-0.4.7.tar.gz'
  sha1 'd2556bf21bef2df99bef0a6d1cb251d5e0f12d3f'

  depends_on :autoconf
  depends_on :automake
  depends_on 'pkg-config' => :build
  depends_on :x11
  depends_on 'gtk+'
  depends_on 'poppler'
  depends_on 'libgnomecanvas'

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make", "install"
  end
end
