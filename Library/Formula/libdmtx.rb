require 'formula'

class Libdmtx < Formula
  homepage 'http://www.libdmtx.org'
  url 'https://downloads.sourceforge.net/project/libdmtx/libdmtx/0.7.4/libdmtx-0.7.4.tar.bz2'
  sha1 '016282df12c4046338b9ff73f3d8b39f023bae16'

  bottle do
    cellar :any
    sha1 "6d2b620ecc37f60047d67166ff6fe3350d578913" => :mavericks
    sha1 "423b105322e2b4690f758c6bbd5a9827c154d2df" => :mountain_lion
    sha1 "2003f4bfa7ad98a897afcae0f5aa2d6e7953b8cb" => :lion
  end

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
