require 'formula'

class ReginaRexx < Formula
  homepage 'http://regina-rexx.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.7/Regina-REXX-3.7.tar.gz'
  sha1 '8d4b06480404d4c659e0613bc04a057b03d0b981'

  def install
    ENV.j1 # No core usage for you, otherwise race condition = missing files.
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
