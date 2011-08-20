require 'formula'

class Newt < Formula
  url 'https://fedorahosted.org/releases/n/e/newt/newt-0.52.13.tar.gz'
  homepage 'https://fedorahosted.org/newt/'
  md5 '77de05b3f58540152a4ae32a1a64e5d0'

  depends_on 'popt'
  depends_on 'tcl'
  depends_on 's-lang'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-nls", "--without-python"
    system "make install"
  end
end