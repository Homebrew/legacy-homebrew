require 'formula'

class Box2d <Formula
  url 'http://box2d.googlecode.com/files/Box2D_v2.1.2.zip'
  homepage 'http://www.box2d.org/'
  md5 '59d142cd8d4d73e8832c7b67591f590c'

  depends_on 'cmake'

  def install
    system "cmake Box2D/ -DBOX2D_BUILD_SHARED=ON -DBOX2D_INSTALL_DOC=ON -DBOX2D_BUILD_EXAMPLES=OFF #{std_cmake_parameters}"
    system "make -C Box2D/ install"
  end
end
