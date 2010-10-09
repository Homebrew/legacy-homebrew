require 'formula'

class Aften <Formula
  url 'http://downloads.sourceforge.net/aften/aften-0.0.8.tar.bz2'
  homepage 'http://aften.sourceforge.net/'
  md5 'fde67146879febb81af3d95a62df8840'

  depends_on 'cmake' => :build

  def install
    Dir.mkdir 'default'
    Dir.chdir 'default' do
      system "cmake .. #{std_cmake_parameters}"
      system "make install"
    end
  end
end
