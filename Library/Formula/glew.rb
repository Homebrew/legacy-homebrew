require 'formula'

class Glew <Formula
  url 'http://downloads.sourceforge.net/project/glew/glew/1.5.4/glew-1.5.4.tgz'
  homepage 'http://glew.sourceforge.net/'
  md5 '492ddb502d7db58924a6fcb244ad4be4'

  def install
    system "mkdir -p #{prefix}/lib/pkgconfig"
    system "make GLEW_DEST=#{prefix}"
    system "make GLEW_DEST=#{prefix} install"
  end
end
