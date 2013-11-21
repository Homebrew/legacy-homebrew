require 'formula'

class Tinycdb < Formula
  homepage 'http://www.corpit.ru/mjt/tinycdb.html'
  url 'http://www.corpit.ru/mjt/tinycdb/tinycdb-0.78.tar.gz'
  sha1 'ade42ee1e7c56f66a63cb933206c089b9983adba'

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}"
  end
end
