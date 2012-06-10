require 'formula'

class Simh < Formula
  homepage 'http://simh.trailing-edge.com/'
  url 'http://simh.trailing-edge.com/sources/simhv39-0.zip'
  sha1 '1de3938f0dcb51d55b0e53aea8ae9769ccc57bdb'
  version '3.9-0'

  # After 3.9-0 the project moves to https://github.com/simh/simh
  # It doesn't actually fail, but the makefile queries llvm-gcc -v --help a lot
  # to determine what flags to throw.  It is simply not designed for clang.
  # Remove at the next revision that will support clang (see github site).
  fails_with :clang do
    build 318
    cause 'The program is closely tied to gcc & llvm-gcc in this revision.'
  end

  def install
    inreplace 'makefile', 'GCC = gcc', "GCC = #{ENV.cc}"
    inreplace 'makefile', 'CFLAGS_O = -O2', "CFLAGS_O = #{ENV.cflags}"
    system "make USE_NETWORK=1 all"
    bin.install Dir['BIN/*']
  end
end
