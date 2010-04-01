require 'formula'

class Glew <Formula
  url 'http://downloads.sourceforge.net/project/glew/glew/1.5.3/glew-1.5.3.tgz'
  homepage 'http://glew.sourceforge.net/'
  md5 '77bb3782128350df2d7ca45f088f0b4b'

  def install
    system "mkdir -p #{prefix}/lib/pkgconfig"
    system "make GLEW_DEST=#{prefix}"
    system "make GLEW_DEST=#{prefix} install"
  end
end
