require 'formula'

class Glew <Formula
  url 'http://downloads.sourceforge.net/project/glew/glew/1.5.8/glew-1.5.8.tgz'
  homepage 'http://glew.sourceforge.net/'
  md5 '342c8dc64fb9daa6af245b132e086bdd'

  def install
    (lib+'pkgconfig').mkpath
    system "make", "GLEW_DEST=#{prefix}"
    system "make", "GLEW_DEST=#{prefix}", "install"
  end
end
