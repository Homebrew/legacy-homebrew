require 'formula'

class Libcaca <Formula
  url 'http://caca.zoy.org/files/libcaca/libcaca-0.99.beta17.tar.gz'
  homepage 'http://caca.zoy.org/wiki/libcaca'
  md5 '790d6e26b7950e15909fdbeb23a7ea87'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-imlib2",
                          "--disable-doc",
                          "--disable-slang"
    system "make install"
  end
end
