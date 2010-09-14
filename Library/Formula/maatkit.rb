require 'formula'

class Maatkit <Formula
  url 'http://maatkit.googlecode.com/files/maatkit-6839.tar.gz'
  homepage 'http://code.google.com/p/maatkit/'
  sha1 'f909e8c48b927032a63539f63d555356635e32aa'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make install"
  end
end
