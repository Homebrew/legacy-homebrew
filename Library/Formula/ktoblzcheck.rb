require 'formula'

class Ktoblzcheck <Formula
  url 'http://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.29.tar.gz'
  homepage 'http://ktoblzcheck.sourceforge.net/'
  md5 '49b3d70f8c735bfb6060edec349565c0'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    ENV.j1
    system "make install"
  end
end
