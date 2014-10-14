require 'formula'

class Gsasl < Formula
  homepage 'http://www.gnu.org/software/gsasl/'
  url 'http://ftpmirror.gnu.org/gsasl/gsasl-1.8.0.tar.gz'
  bottle do
    cellar :any
    sha1 "c8969703477919ee6a2b5167cdf7b01f8d66f141" => :mavericks
    sha1 "94392f71f7dee64eb0ddcbb453d7b4b4ecbc9ffc" => :mountain_lion
    sha1 "48f65101534df57a8d1a6cd611f800fecc9e5875" => :lion
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
