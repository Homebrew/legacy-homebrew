require 'formula'

class Html2text < Formula
  url 'http://www.mbayer.de/html2text/downloads/html2text-1.3.2a.tar.gz'
  homepage 'http://www.mbayer.de/html2text/'
  md5 '6097fe07b948e142315749e6620c9cfc'

  def install
    inreplace 'configure',
              'for i in "CC" "g++" "cc" "$CC"; do',
              'for i in "g++"; do'

    system "./configure"
    system "make all"

    bin.install "html2text"
    man1.install "html2text.1.gz"
    man5.install "html2textrc.5.gz"
  end
end
