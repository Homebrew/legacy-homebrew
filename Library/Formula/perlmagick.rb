require "formula"

class Perlmagick < Formula
  homepage "http://www.imagemagick.org/script/perl-magick.php"
  url "http://www.imagemagick.org/download/perl/PerlMagick-6.89.tar.gz"
  sha256 "c8f81869a4f007be63e67fddf724b23256f6209f16aa95e14d0eaef283772a59"
  revision 1

  bottle do
    sha1 "ce1cf658507f5269ea3167a9d6f83ff4e38b9749" => :mavericks
    sha1 "939ec50e438de4caf808f324e9949a5a75c13eb8" => :mountain_lion
    sha1 "c040bc6e0b238c49c076414b5a082b4b54047406" => :lion
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
