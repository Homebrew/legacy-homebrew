require 'formula'

class Tcptrace <Formula
  url 'http://www.tcptrace.org/download/tcptrace-6.6.7.tar.gz'
  homepage 'http://www.tcptrace.org/'
  md5 '68128dc1817b866475e2f048e158f5b9'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make tcptrace"

    bin.install 'tcptrace'
    mv 'tcptrace.man', 'tcptrace.1'
    man1.install 'tcptrace.1'
  end
end
