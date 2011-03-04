require 'formula'

class Monotone <Formula
  url 'http://www.monotone.ca/downloads/0.48.1/monotone-0.48.1.tar.gz'
  homepage 'http://www.monotone.ca/'
  md5 'b5fa9e3b02ca3dcaf58fb7a2519ef956'

  depends_on 'pkg-config' => :build
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
