require "formula"

class Perlmagick < Formula
  homepage "http://www.imagemagick.org/script/perl-magick.php"
  url "http://www.imagemagick.org/download/perl/PerlMagick-6.89.tar.gz"
  sha256 "c8f81869a4f007be63e67fddf724b23256f6209f16aa95e14d0eaef283772a59"
  revision 1

  bottle do
    sha1 "6efa2e6d746ab5d38cc4ca06251fb81a7125a8f8" => :mavericks
    sha1 "7fdaa41367a66a4ccec92df933f88d5952233f1c" => :mountain_lion
    sha1 "035a0402685b6c7fb4fcd894e8b4a76ed3f22c75" => :lion
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
