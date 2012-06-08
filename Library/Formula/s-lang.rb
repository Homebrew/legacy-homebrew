require 'formula'

class SLang < Formula
  url 'ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2'
  homepage 'http://www.jedsoft.org/slang/'
  md5 '7fcfd447e378f07dd0c0bae671fe6487'

  depends_on :x11
  depends_on 'pcre' => :optional
  depends_on 'oniguruma' => :optional

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-png=#{MacOS.x11_prefix}"
    ENV.j1
    system "make"
    system "make install"
  end
end
