require 'formula'

class Libebur128 < Formula
  homepage 'https://github.com/jiixyj/libebur128'
  url 'https://github.com/jiixyj/libebur128/archive/v1.0.2.tar.gz'
  sha1 'b1e2949e6598053edb8aeaf71614a26efcb38bd0'

  depends_on 'cmake' => :build
  depends_on 'speex' => [:optional, 'with-libogg']

  def install
    args = std_cmake_args
    system 'cmake', '.', *args
    system 'make install'
  end
end
