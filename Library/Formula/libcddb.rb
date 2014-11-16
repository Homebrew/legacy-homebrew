require 'formula'

class Libcddb < Formula
  homepage 'http://libcddb.sourceforge.net/'
  url 'https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2'
  sha1 '2a7855918689692ff5ca3316d078a859d51959ce'

  bottle do
    cellar :any
    revision 1
    sha1 "253045ed49df247223574bae9888b3119ebd995b" => :yosemite
    sha1 "5589c76a2a1abe8e11aedb05ec3b6510b47f7394" => :mavericks
    sha1 "a23458d0ab82864cb515dfd7c84f5e363de9e7a5" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libcdio'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
