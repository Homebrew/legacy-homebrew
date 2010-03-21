require 'formula'

class Maatkit <Formula
  url 'http://maatkit.googlecode.com/files/maatkit-5899.tar.gz'
  homepage 'http://code.google.com/p/maatkit/'
  md5 'eb934c6bcf8604a1fd6c65a625fa8740'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make install"
  end
end
