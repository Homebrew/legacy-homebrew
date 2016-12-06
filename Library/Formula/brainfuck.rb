require 'formula'

class Brainfuck < Formula
  homepage 'http://www.muppetlabs.com/~breadbox/bf/'
  head 'https://github.com/FabianM/brainfuck.git'

  def install
    system 'make all'
    bin.install 'bin/brainfuck'
    man1.install 'man/brainfuck_darwin.1'
  end

  def test
    system 'brainfuck'
  end
end

