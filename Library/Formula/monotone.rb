require 'formula'

class Monotone <Formula
  url 'http://www.monotone.ca/downloads/0.48/monotone-0.48.tar.gz'
  homepage 'http://www.monotone.ca/'
  md5 '330a1fe1d92c899d1ad539606f85a9f8'

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'botan'
  depends_on 'boost'
  depends_on 'libidn'
  depends_on 'lua'
  depends_on 'pcre'

  def install
    fails_with_llvm "linker fails"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
