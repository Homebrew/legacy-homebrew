require 'formula'

class Ejdb < Formula
  homepage 'http://ejdb.org/'
  url 'https://github.com/Softmotions/ejdb/archive/v1.1.25.tar.gz'
  sha1 'be8a864286f2b28922a04c9ba3f9eac830d8ebdd'

  def install
    cd 'tcejdb' do
      system "./configure", "--prefix=#{prefix}", "--disable-debug"
      system "make"
      system "make install"
    end
  end
end
