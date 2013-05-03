require 'formula'

class Liblqr < Formula
  homepage 'http://liblqr.wikidot.com/'
  url 'http://liblqr.wdfiles.com/local--files/en:download-page/liblqr-1-0.4.2.tar.bz2'
  version '0.4.2'
  sha1 '69639f7dc56a084f59a3198f3a8d72e4a73ff927'

  head 'git://repo.or.cz/liblqr.git'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
