require 'formula'

class Libidn <Formula
  url 'http://ftp.gnu.org/gnu/libidn/libidn-1.19.tar.gz'
  homepage 'http://www.gnu.org/software/libidn/'
  sha1 '2b6dcb500e8135a9444a250d7df76f545915f25f'

  depends_on 'gettext'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--disable-csharp"
    system "make install"
  end
end
