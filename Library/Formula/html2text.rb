require 'formula'

class Html2text < Formula
  homepage 'http://www.mbayer.de/html2text/'
  url 'http://www.mbayer.de/html2text/downloads/html2text-1.3.2a.tar.gz'
  sha1 '91d46e3218d05b0783bebee96a14f0df0eb9773e'

  # Patch provided by author. See:
  # http://www.mbayer.de/html2text/faq.shtml#sect6
  def patches
    "http://www.mbayer.de/html2text/downloads/patch-utf8-html2text-1.3.2a.diff"
  end

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
