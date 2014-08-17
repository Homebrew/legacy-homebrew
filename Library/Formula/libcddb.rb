require 'formula'

class Libcddb < Formula
  homepage 'http://libcddb.sourceforge.net/'
  url 'https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2'
  sha1 '2a7855918689692ff5ca3316d078a859d51959ce'

  bottle do
    cellar :any
    sha1 "e663db6e8362f7e4f6953e7f02d9e3751f64a836" => :mavericks
    sha1 "9c9de1cf8eb40cadbdac48dd65520f6614dbf5e4" => :mountain_lion
    sha1 "82190e9f5174f6850e5e94ead820281e1e8ced08" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libcdio'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
