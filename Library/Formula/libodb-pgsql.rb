require 'formula'

class LibodbPgsql < Formula
  homepage 'http://www.codesynthesis.com/products/odb/'
  url 'http://www.codesynthesis.com/download/odb/2.2/libodb-pgsql-2.2.0.tar.gz'
  sha1 '10eb2dfa5b9ff6c81fa03b00442661e3da7b664c'

  depends_on 'libodb'

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "false"
  end
end
