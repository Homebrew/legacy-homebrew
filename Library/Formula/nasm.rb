require 'formula'

class Nasm < Formula
  homepage 'http://www.nasm.us/'
  url 'http://www.nasm.us/pub/nasm/releasebuilds/2.10.01/nasm-2.10.01.tar.bz2'
  sha256 'ac9b37d265c35492ab1bc29dd5a4f3da11b42dd9fea7a31d95f6cb4c812bda84'

  def options
    [[ '--universal', 'Build a universal binary' ]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--prefix=#{prefix}"
    system "make everything"
    system "make install_everything"
  end
end
