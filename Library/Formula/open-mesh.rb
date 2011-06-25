require 'formula'

class OpenMesh < Formula
  url 'http://openmesh.org/fileadmin/openmesh-files/2.0RC5/OpenMesh-2.0-RC5.tar.gz'
  homepage 'http://www.openmesh.org'
  md5 '9b4f24a7b1a31cfd65aada58672a6c09'

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'glew'

  def install
    mkdir 'openmesh-build'
    Dir.chdir 'openmesh-build' do
      system "cmake .. -DCMAKE_INSTALL_PREFIX='#{prefix}' -DCMAKE_BUILD_TYPE=Release"
      system "make"
      system "make install"
    end
  end
end
