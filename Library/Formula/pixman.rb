require 'formula'

class Pixman < Formula
  homepage 'http://www.cairographics.org/'
  url 'http://cairographics.org/releases/pixman-0.24.2.tar.gz'
  sha1 'acfc724d8032d3c0677b4466807e120e0c867678'

  depends_on 'pkg-config' => :build

  def install
    if ENV.compiler == :llvm
      if MacOS.xcode_version >= "4.1"
        ENV.clang
      else
        ENV.gcc_4_2
      end
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gtk=no" # Don't need to build tests
    system "make install"
  end
end
