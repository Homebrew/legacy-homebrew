require 'formula'

class Yydecode < Formula
  homepage 'http://yydecode.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/yydecode/yydecode/0.2.10/yydecode-0.2.10.tar.gz'
  sha1 '27b1e6a3c6f8fa92a487a517fdb05c4e3e0c454a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
