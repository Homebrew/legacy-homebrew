require 'formula'

class LibodbBoost < Formula
  homepage 'http://www.codesynthesis.com/products/odb/'
  url 'http://www.codesynthesis.com/download/odb/2.2/libodb-boost-2.2.0.tar.gz'
  sha1 'fdf57dba0618266e7b948c7e40e09ae2b128dbca'

  depends_on 'libodb'
  depends_on 'boost'

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "false"
  end
end
