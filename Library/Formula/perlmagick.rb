require "formula"

class Perlmagick < Formula
  homepage "http://www.imagemagick.org/script/perl-magick.php"
  url "http://www.imagemagick.org/download/perl/PerlMagick-6.88.tar.gz"
  sha1 "f234b49a5c570f78d693c04924fe74ddb5595292"

  depends_on "freetype"
  depends_on "libxml2"
  depends_on "imagemagick"
  depends_on :x11

  def install
    inreplace "Makefile.PL", "-I/usr/include/libxml2", "-I#{HOMEBREW_PREFIX}/include/libxml2"
    inreplace "Makefile.PL", "-I/usr/include/freetype2", "-I#{HOMEBREW_PREFIX}/include/freetype2"
    inreplace "Makefile.PL", "'INSTALLBIN'	=> '/usr/local/bin'", "'INSTALLBIN'	=> '#{bin}'"
    inreplace "Makefile.PL", "# 'PREFIX'	=> '/usr/local'", "'PREFIX'	=> '#{prefix}'"

    system "perl", "Makefile.PL"
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    You might need to define PerlMagick's Perl library directory.

        PERL5LIB=#{prefix}/lib/perl5/site_perl/5.16.2

    EOS
  end
end
