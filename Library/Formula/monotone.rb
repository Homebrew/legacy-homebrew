require 'formula'

class Monotone <Formula
  url 'http://www.monotone.ca/downloads/0.46/monotone-0.46.tar.gz'
  homepage 'http://www.monotone.ca/'
  md5 '405286223efcf375cd022dabf2f1c845'

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'botan'
  depends_on 'boost'
  depends_on 'libidn'
  depends_on 'lua'
  depends_on 'pcre'

  def install
    # linker fails
    ENV.gcc_4_2

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
