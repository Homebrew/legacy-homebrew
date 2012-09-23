require 'formula'

class ReginaRexx < Formula
  homepage 'http://regina-rexx.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.6/Regina-REXX-3.6.tar.gz'
  sha1 '6e7709bc07b22f4b26cb1893a967f499c304b26a'

  def install
    ENV.j1 # No core usage for you, otherwise race condition = missing files.
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
