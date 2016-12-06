require 'formula'

class Libpqxx < Formula
  homepage 'http://pqxx.org/development/libpqxx/'
  url 'http://pqxx.org/download/software/libpqxx/libpqxx-4.0.tar.gz'
  sha1 '09e6301e610e7acddbec85f4803886fd6822b2e6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "false"
  end
end
