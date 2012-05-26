require 'formula'


class Libpqxx < Formula
  homepage 'http://pqxx.org/development/libpqxx/'
  url 'http://pqxx.org/download/software/libpqxx/libpqxx-4.0.tar.gz'
  md5 'bd7541f858400a96cbe2a48cb342ad0e'

  depends_on 'postgresql' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    system "pqxx-config --version"
  end
end
