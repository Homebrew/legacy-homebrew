require 'formula'

class Ldc < Formula
  head 'https://github.com/ldc-developers/ldc.git'
  homepage 'https://github.com/ldc-developers/ldc/wiki'

  depends_on 'cmake' => :build
  depends_on 'llvm'
  depends_on 'libconfig'

  def install
    system "cmake -DCMAKE_INSTALL_PREFIX:PATH=/#{prefix} ."
    system "make", "install"
  end
end
