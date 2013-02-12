require 'formula'

class Gawk < Formula
  homepage 'http://www.gnu.org/software/gawk/'
  url 'http://ftpmirror.gnu.org/gawk/gawk-4.0.2.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/gawk/gawk-4.0.2.tar.xz'
  sha1 '816277597445c4b52ab2c2084ec940e13422fb3c'

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
