require 'formula'

class X264 <Formula
  head 'git://git.videolan.org/x264.git', :tag => '114461'
  depends_on 'yasm'

  homepage 'http://www.videolan.org/developers/x264.html'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking","--enable-shared"
    system "make install"
  end
end
