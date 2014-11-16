require 'formula'

class Sylpheed < Formula
  homepage 'http://sylpheed.sraoss.jp/en/'
  url 'http://sylpheed.sraoss.jp/sylpheed/v3.3/sylpheed-3.3.0.tar.bz2'
  sha1 '07b7dd7f0b58065b6f8db7a3b443240aade7da6a'

  depends_on 'pkg-config' => :build
  depends_on :x11
  depends_on 'gpgme'
  depends_on 'gtk+'
  depends_on 'cairo'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-updatecheck"
    system "make install"
  end
end
