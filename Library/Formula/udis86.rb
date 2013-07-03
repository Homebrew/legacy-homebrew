require 'formula'

class Udis86 < Formula
  homepage 'http://udis86.sourceforge.net'
  url 'http://downloads.sourceforge.net/udis86/udis86-1.7.1.tar.gz'
  sha1 '45fd0b93ca671683d978c7faf9eda195f0f8fde9'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make install"
  end
end
