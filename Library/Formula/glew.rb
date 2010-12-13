require 'formula'

class Glew <Formula
  url 'http://downloads.sourceforge.net/project/glew/glew/1.5.7/glew-1.5.7.tgz'
  homepage 'http://glew.sourceforge.net/'
  md5 'f913ce9dbde4cd250b932731b3534ded'

  def install
    (lib+'pkgconfig').mkpath
    system "make", "GLEW_DEST=#{prefix}"
    system "make", "GLEW_DEST=#{prefix}", "install"
  end
end
