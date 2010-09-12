require 'formula'

class Ktoblzcheck <Formula
  url 'http://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck/ktoblzcheck-1.24.tar.gz'
  homepage 'http://ktoblzcheck.sourceforge.net/'
  md5 '6385d5eca2db5f7eb3bd49312166eaf7'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    ENV.j1
    system "make install"
  end
end
