require 'formula'

class OpenMesh < Formula
  homepage 'http://openmesh.org'
  url 'http://www.openmesh.org/fileadmin/openmesh-files/2.3/OpenMesh-2.3.tar.gz'
  sha1 '3cccb46afd6f8b0c60dfbdcd883806f77efd14c3'

  head 'http://openmesh.org/svnrepo/OpenMesh/trunk/', :using => :svn

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'glew'

  def install
    mkdir 'openmesh-build' do
      system "cmake -DCMAKE_INSTALL_PREFIX='#{prefix}' -DCMAKE_BUILD_TYPE=Release .."
      system "make install"
    end
  end

  def test
    system "#{bin}/mconvert", '-help'
  end
end
