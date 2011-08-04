require 'formula'

class Perl < Formula
  url 'http://www.cpan.org/src/5.0/perl-5.14.1.tar.gz'
  homepage 'http://www.perl.org/'
  md5 '0b74cffa3a10aee08442f950aecbaeec'

  def install
    system("rm -f config.sh Policy.sh");
    system "./Configure", "-des", "-Dprefix=#{prefix}",
      # HACK: Force mandirs to use brew-friendly paths
      "-Dman1dir=#{man1}", "-Dman3dir=#{man3}",
      "-Dusethreads", "-Duseshrplib", "-Duselargefiles"
    system "make"
    system "make test"
    system "make install"
  end
end