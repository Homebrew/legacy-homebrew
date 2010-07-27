require 'formula'

class Maatkit <Formula
  url 'http://maatkit.googlecode.com/files/maatkit-6652.tar.gz'
  homepage 'http://code.google.com/p/maatkit/'
  md5 'b21a7ee121aa207279761121e00d589a'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make install"
  end
end
