require 'formula'

class Nasm < Formula
  homepage 'http://www.nasm.us/'
  url 'http://www.nasm.us/pub/nasm/releasebuilds/2.10.04/nasm-2.10.04.tar.bz2'
  sha256 '6ad90fca575fc87d4b093c3f84f3148ef9f0453471723f4971ccbddaa9882b27'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make everything"
    system "make install_everything"
  end
end
