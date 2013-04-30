require 'formula'

class Brainfuck < Formula
  homepage 'https://github.com/FabianM/brainfuck'
  url 'https://github.com/FabianM/brainfuck/archive/0.1.2.tar.gz'
  sha1 'c656c932ede90972f1b3c3cfeb15b3cc1df0caea'

  def install
    system "make", "all", "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}"
    bin.install 'bin/brainfuck'
    man1.install 'man/brainfuck.1'
  end

  test do
    system "#{bin}/brainfuck | cat"
  end
end
