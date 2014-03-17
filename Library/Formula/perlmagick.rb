require "formula"

class Perlmagick < Formula
  homepage "http://www.imagemagick.org/script/perl-magick.php"
  url "http://www.imagemagick.org/download/perl/PerlMagick-6.88.tar.gz"
  sha1 "f234b49a5c570f78d693c04924fe74ddb5595292"

  depends_on "freetype"
  depends_on "imagemagick"

  def install
    inreplace "Makefile.PL" do |s|
      s.gsub! "-I/usr/include/freetype2", "-I#{Formula["freetype"].include}/freetype2"
      s.gsub! "'INSTALLBIN'	=> '/usr/local/bin'", "'INSTALLBIN'	=> '#{bin}'"
      s.gsub! "# 'PREFIX'	=> '/usr/local'", "'PREFIX'	=> '#{prefix}'"
    end

    system "perl", "Makefile.PL"
    system "make"
    system "make", "install"
  end

  # References the system Perl version.
  def caveats; <<-EOS.undent
     You may need to define the Perl library directory for PerlMagick.
       export PERL5LIB="#{HOMEBREW_PREFIX}/lib/perl5/site_perl/5.16.2"
    EOS
  end
end
