require 'formula'

class Maatkit <Formula
  url 'http://maatkit.googlecode.com/files/maatkit-6070.tar.gz'
  homepage 'http://code.google.com/p/maatkit/'
  md5 '313e7b01c0a718a84055112d0060e45e'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make install"
  end
end
