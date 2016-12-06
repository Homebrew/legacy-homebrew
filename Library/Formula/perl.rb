require 'formula'

class Perl <Formula
  url 'http://www.cpan.org/src/5.0/perl-5.12.2.tar.gz'
  homepage 'http://perl.org'
  md5 'af2df531d46b77fdf0d97eecb03eddb2'

  # Don't strip binaries or libs
  skip_clean ['bin', 'lib']

  def install
    system "sh Configure -des -Dprefix=#{prefix}"
    system "make install"

    # Homebrew wants man pages in share/
    system "mkdir #{share} && mv #{prefix}/man #{share}/"
  end
end
