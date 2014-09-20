require 'formula'

class Libksba < Formula
  homepage 'http://www.gnupg.org/related_software/libksba/index.en.html'
  url 'ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.3.1.tar.bz2'
  mirror 'http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libksba/libksba-1.3.1.tar.bz2'
  sha1 '6bfe285dbc3a7b6e295f9389c20ea1cdf4947ee5'

  bottle do
    cellar :any
    sha1 "e3d69fd49c3970da47b084ef6faecf6c1865f15c" => :mavericks
    sha1 "87668c3f1fe99638c308788a7e0e2769bcd61309" => :mountain_lion
    sha1 "add30a335e98dcc4a582e2ea94e6221530d3b45f" => :lion
  end

  depends_on 'libgpg-error'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
