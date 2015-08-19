class Libcddb < Formula
  desc "CDDB server access library"
  homepage "http://libcddb.sourceforge.net/"
  url "https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2"
  sha256 "35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b"

  bottle do
    cellar :any
    revision 1
    sha1 "253045ed49df247223574bae9888b3119ebd995b" => :yosemite
    sha1 "5589c76a2a1abe8e11aedb05ec3b6510b47f7394" => :mavericks
    sha1 "a23458d0ab82864cb515dfd7c84f5e363de9e7a5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
