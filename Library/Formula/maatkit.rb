require 'formula'

class Maatkit <Formula
  url 'http://maatkit.googlecode.com/files/maatkit-6960.tar.gz'
  homepage 'http://code.google.com/p/maatkit/'
  sha1 'ad8dd1d9e476f79e7e91f98919a2ae7c5b8a2c20'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make install"
  end
end
