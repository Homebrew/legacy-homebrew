require 'formula'

class Tcptrace < Formula
  homepage 'http://www.tcptrace.org/'
  url 'http://www.tcptrace.org/download/tcptrace-6.6.7.tar.gz'
  sha1 'ae4d10a0829c57f2eda17e63f593e558f52b7f24'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make tcptrace"

    bin.install 'tcptrace'
    man1.install 'tcptrace.man' => 'tcptrace.1'
  end
end
