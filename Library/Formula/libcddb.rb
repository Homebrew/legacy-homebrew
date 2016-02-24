class Libcddb < Formula
  desc "CDDB server access library"
  homepage "http://libcddb.sourceforge.net/"
  url "https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2"
  sha256 "35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b"

  bottle do
    cellar :any
    revision 1
    sha256 "df0e468bf540a6a17547a68f257b1322037b87beb42889970e1c24b3b564a22a" => :yosemite
    sha256 "8aabe8dff95e4df0fc4ad31371d9bad735b48e592aba072b10d935c71f65b0f4" => :mavericks
    sha256 "0937c3e65e3b0263e2148548bdb532a2541df0e16f0074bf70a9f994e5f9b9d1" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
