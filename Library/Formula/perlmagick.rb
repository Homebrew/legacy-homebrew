class Perlmagick < Formula
  desc "Objected-oriented Perl interface to ImageMagick"
  homepage "http://www.imagemagick.org/script/perl-magick.php"
  url "http://www.imagemagick.org/download/perl/PerlMagick-6.89.tar.gz"
  sha256 "c8f81869a4f007be63e67fddf724b23256f6209f16aa95e14d0eaef283772a59"
  revision 1

  bottle do
    sha256 "2ac8b23b7b1f1e8c0b85fdf4d44cb12813744e899604abed5524684c7be5a687" => :mavericks
    sha256 "59f5ede00a0f376aebb5010a04a8b3a8545db8d4b86e6ff79e0072e90cf74a56" => :mountain_lion
    sha256 "3dd6bb5a60023b31bc7f350c1dd6fac58f0511beb110a69831ea7031537deb1d" => :lion
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
  def caveats
    perl_version = `/usr/bin/perl -e 'printf "%vd", $^V;'`
    <<-EOS.undent
      You need to define the OS X system Perl library directory to use PerlMagick:
        export PERL5LIB="#{HOMEBREW_PREFIX}/lib/perl5/site_perl/#{perl_version}"
    EOS
  end
end
