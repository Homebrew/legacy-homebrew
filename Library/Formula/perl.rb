require 'formula'

class Perl < Formula
  url 'http://www.cpan.org/src/5.0/perl-5.12.3.tar.gz'
  homepage 'http://www.perl.org/'
  md5 '29975a69dce54e47fcd6331c085c6c99'

  def install
    system("rm -f config.sh Policy.sh");
    system "sh Configure -de -Dprefix=#{prefix} -Dusethreads -Duseshrplib -Duselargefiles"
    system "make install"
  end
end
