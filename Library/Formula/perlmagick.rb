require "formula"

class Perlmagick < Formula
  homepage "http://www.imagemagick.org/script/perl-magick.php"
  url "http://www.imagemagick.org/download/perl/PerlMagick-6.88.tar.gz"
  sha1 "f234b49a5c570f78d693c04924fe74ddb5595292"

  depends_on :freetype
  depends_on "imagemagick"

  def install
    freetype_inc = "#{MacOS::X11.include}/freetype2/freetype" if MacOS::X11.installed? else "#{Formula["freetype"].opt_prefix}"
    inreplace "Makefile.PL" do |s|
      s.gsub! "-I/usr/include/freetype2", "-I#{freetype_inc}"
      s.gsub! "'INSTALLBIN'	=> '/usr/local/bin'", "'INSTALLBIN'	=> '#{bin}'"
      s.gsub! "# 'PREFIX'	=> '/usr/local'", "'PREFIX'	=> '#{prefix}'"
    end

    system "perl", "Makefile.PL"
    system "make"
    system "make", "install"
  end

  def caveats;
    version = "#{Dir.entries ("#{lib}/perl5/site_perl").reject{|entry| entry == "." || entry == ".."}}"
    perllib = File.join ("#{HOMEBREW_PREFIX}/lib/perl5/site_perl", version)
   <<-EOS.undent
     You might need to define the Perl library directory for PerlMagick.

       export PERL5LIB=#{perllib}
   EOS
  end
end
