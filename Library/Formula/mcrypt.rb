require 'formula'

class Mcrypt < Formula
  url 'ftp://mirror.internode.on.net/pub/gentoo/distfiles/libmcrypt-2.5.8.tar.gz'
  homepage 'http://mcrypt.sourceforge.net'
  md5 '0821830d930a86a5c69110837c55b7da'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
