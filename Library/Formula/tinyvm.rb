require 'formula'

class Tinyvm < Formula
  homepage 'https://github.com/GenTiradentes/tinyvm'
  url 'https://github.com/GenTiradentes/tinyvm/tarball/v1.0'
  md5 '64cbb0d368e24c02d5d86e3d8e5a42c1'

  head 'https://github.com/GenTiradentes/tinyvm.git'

  def install
   inreplace 'Makefile' do |s|
      s.remove_make_var! 'CC'
    end
    system "make"
    bin.install "tinyvm"
    (share+'tinyvm').install Dir['programs/*'] + %w(README SYNTAX)
  end

  def caveats; <<-EOS.undent
    Vitual machines have been installed here:
      #{share}/tinyvm
    EOS
  end

  def test
    system "tinyvm", share+'tinyvm/stack_bench.vm'
  end
end
