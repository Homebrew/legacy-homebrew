require 'formula'

class Glew <Formula
  url 'http://downloads.sourceforge.net/project/glew/glew/1.5.5/glew-1.5.5.tgz'
  homepage 'http://glew.sourceforge.net/'
  md5 '3621f27cfd3e33d5dbcc1111ecb5b762'

  def install
    (lib+'pkgconfig').mkpath
    system "make", "GLEW_DEST=#{prefix}"
    system "make", "GLEW_DEST=#{prefix}", "install"
  end
end
