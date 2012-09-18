require 'formula'

class Mcrypt < Formula
  url 'http://sourceforge.net/projects/mcrypt/files/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz'
  homepage 'http://mcrypt.sourceforge.net'
  sha1 '9a426532e9087dd7737aabccff8b91abf9151a7a'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
