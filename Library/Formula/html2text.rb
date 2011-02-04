require 'formula'

class Html2text <Formula
  url 'http://www.mbayer.de/html2text/downloads/html2text-1.3.2a.tar.gz'
  homepage 'http://www.mbayer.de/html2text/'
  md5 '6097fe07b948e142315749e6620c9cfc'

  def install
    # Fix the compiler...
    inreplace 'configure',
              'for i in "CC" "g++" "cc" "$CC"; do',
              'for i in "g++"; do'
    # Configure...
    system "./configure"
    # Build...
    system "make all"
    # Install...
    system "/usr/bin/install", "-d", bin, man1, man5
    system "/usr/bin/install", "-m", "755", "html2text", bin
    system "/usr/bin/install", "-m", "644", "html2text.1.gz", man1
    system "/usr/bin/install", "-m", "644", "html2textrc.5.gz", man5
  end
end
