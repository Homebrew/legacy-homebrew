require 'formula'

class Teapot < Formula
  homepage 'http://www.syntax-k.de/projekte/teapot/'
  url 'http://www.syntax-k.de/projekte/teapot/teapot-2.3.0.tar.gz'
  sha1 'cac70c7967ba72166cdbd1806b674cd8299399e7'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args + ['-DENABLE_HELP=OFF', '..']
    mkdir 'macbuild' do
      system 'cmake', *args
      system 'make install'
    end
  end
end
