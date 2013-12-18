require 'formula'

class Gsasl < Formula
  homepage 'http://www.gnu.org/software/gsasl/'
  url 'http://ftpmirror.gnu.org/gsasl/gsasl-1.8.0.tar.gz'
  mirror 'http://ftp.gnu.org/gsasl/gsasl-1.8.0.tar.gz'
  sha1 '343fd97ae924dc406986c02fb9b889f4114239ae'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
