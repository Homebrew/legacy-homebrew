require 'formula'

class Codemod < Formula
  homepage 'https://github.com/facebook/codemod'
  url 'https://github.com/facebook/codemod.git', :revision => 'a1bb6f71c3642242a6575154f5903858e3b19f5b'
  version 'a1bb6f71c3642242a6575154f5903858e3b19f5b'
  head 'https://github.com/facebook/codemod.git'

  depends_on :python2

  def install
    python do
      system python, 'setup.py', 'install', "--prefix=#{prefix}"
      bin.install_symlink 'codemod.py' => 'codemod'
    end
  end

  def caveats
    python.standard_caveats if python
  end

  test do
    system "#{bin}/codemod", '--test'
  end
end
