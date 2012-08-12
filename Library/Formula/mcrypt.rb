require 'formula'

class Mcrypt < Formula
  url 'http://sourceforge.net/projects/mcrypt/files/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz'
  homepage 'http://mcrypt.sourceforge.net'
  md5 '0821830d930a86a5c69110837c55b7da'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
