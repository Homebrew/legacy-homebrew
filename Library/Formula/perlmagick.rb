require "formula"

class Perlmagick < Formula
  homepage "http://www.imagemagick.org/script/perl-magick.php"
  url "http://www.imagemagick.org/download/perl/PerlMagick-6.88.tar.gz"
  sha1 "f234b49a5c570f78d693c04924fe74ddb5595292"

  bottle do
    revision 1
    sha1 "86285696b717954a1a64a94df70f5701523b1403" => :mavericks
    sha1 "96de2b7c175b6682fb74c0f2353fca9d50f3529d" => :mountain_lion
    sha1 "a468f8f61603cc0c3daa21c077bf156ef7ae1266" => :lion
  end

  depends_on "freetype"
  depends_on "imagemagick"

  def install
    inreplace "Makefile.PL" do |s|
      s.gsub! "INC_magick = '-I/usr/local/include/ImageMagick-6", "INC_magick = '-I#{Formula["imagemagick"].include}/ImageMagick-6"
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
