require 'formula'

class LibodbSqlite < Formula
  homepage 'http://www.codesynthesis.com/products/odb/'
  url 'http://www.codesynthesis.com/download/odb/2.2/libodb-sqlite-2.2.1.tar.gz'
  sha1 'e322a5d8335657d6fb12092943c5dfc87e087e31'

  depends_on 'libodb'
  depends_on 'sqlite'

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "false"
  end
end
