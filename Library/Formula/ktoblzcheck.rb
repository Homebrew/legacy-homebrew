require 'formula'

class Ktoblzcheck <Formula
  url 'http://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.31.tar.gz'
  homepage 'http://ktoblzcheck.sourceforge.net/'
  md5 '2bc5fd7b3d6785527f7f0ea565c35e29'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    ENV.j1
    system "make install"
  end
end
