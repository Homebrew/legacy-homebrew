require 'formula'

class Nylon <Formula
  url 'http://monkey.org/~marius/nylon/nylon-1.21.tar.gz'
  md5 'd5de81422b8797afa328f72c694b65bb'
  homepage 'http://monkey.org/~marius/pages/?page=nylon'

  depends_on 'libevent'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-libevent=#{HOMEBREW_PREFIX}", "--mandir=#{man}"
    system "make install"
  end
end
