require 'formula'

class Gawk < Formula
  homepage 'http://www.gnu.org/software/gawk/'
  url 'http://ftpmirror.gnu.org/gawk/gawk-4.0.1.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/gawk/gawk-4.0.1.tar.xz'
  sha1 '9be956d124e0c0794836055846aea78d2dc547ad'

  depends_on 'xz' => :build

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.j1 # Run tests serialized
    system "make check"
    system "make install"
  end
end
