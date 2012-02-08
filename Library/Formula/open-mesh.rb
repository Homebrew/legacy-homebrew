require 'formula'

class OpenMesh < Formula
  url 'http://openmesh.org/fileadmin/openmesh-files/2.1/OpenMesh-2.1.tar.bz2'
  homepage 'http://openmesh.org'
  md5 'e28ede60a261b92b7da517be71387b39'
  head 'http://openmesh.org/svnrepo/OpenMesh/trunk/', :using => :svn

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'glew'

  def install
    mkdir 'openmesh-build'
    Dir.chdir 'openmesh-build' do
      system "cmake .. -DCMAKE_INSTALL_PREFIX='#{prefix}' -DCMAKE_BUILD_TYPE=Release"
      system "make install"
    end
  end

  def test
    system("#{bin}/mconvert", '-help')
  end
end

