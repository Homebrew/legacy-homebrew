require 'formula'

class Xz <Formula
  url 'http://tukaani.org/xz/xz-4.999.9beta.tar.bz2'
  homepage 'http://tukaani.org/xz/'
  md5 'cc4044fcc073b8bcf3164d1d0df82161'
  version '4.999.9beta' # *shrug*

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
