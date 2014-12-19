require 'formula'

class Gsasl < Formula
  homepage 'http://www.gnu.org/software/gsasl/'
  url 'http://ftpmirror.gnu.org/gsasl/gsasl-1.8.0.tar.gz'
  bottle do
    cellar :any
    revision 1
    sha1 "2b96e98966ea3d2b9b362c1adbcf18fc461a73ee" => :yosemite
    sha1 "ab5cf602f822e6b4e9aab31fa752fc0f22b0e09a" => :mavericks
    sha1 "bf3355e1963568a4282ec50bb3d2dfebb5f6b190" => :mountain_lion
  end

  mirror 'http://ftp.gnu.org/gsasl/gsasl-1.8.0.tar.gz'
  sha1 '343fd97ae924dc406986c02fb9b889f4114239ae'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
