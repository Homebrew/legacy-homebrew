require 'formula'

class Xcftools < Formula
  homepage 'http://henning.makholm.net/software#xcftools'
  url 'http://henning.makholm.net/xcftools/xcftools-1.0.7.tar.gz'
  version '1.0.7'
  sha1 '3c3cf07ad6183605a3febf5a8af9f2bd4cb4ef83'

  depends_on 'netpbm'
  depends_on :libpng
  
  option 'run-tests', "Run the xcftools test suite before installing"

  def install
    ENV.x11
    ENV.j1
    ENV.deparallelize
    
    netpbm = Formula.factory 'netpbm'
    ENV['RGBDEF'] = "#{netpbm.prefix}/misc/rgb.txt"

    cd "test" do
      inreplace "dotest" do |s|
        s.gsub! /zcat/, "gzcat"
        s.gsub! /-oo\./, "-o o."
        s.gsub! /--pipe/, "-Z"
        s.gsub! /-@/, ""
        s.gsub! /(\S+)\.xcf\.gz/, " -z \\1.xcf.gz"
      end
      cd "source" do
        inreplace "mkbase.i" do |s|
          s.gsub! /png_voidp_NULL/, "NULL"
          s.gsub! /png_error_ptr_NULL/, "NULL"
        end
      end
    end
    
    inreplace "options.i" do |s|
      s.gsub! /"zcat"/, "\"gzcat\""
      s.gsub! /\'\'s/, ""
    end
    
    inreplace "Makefile.in" do |s|
      s.gsub! /touch \$\^/, "touch manpo/*.po"
      s.gsub! /@ -D/, "@"
    end
    
    inreplace "mkopti.pl" do |s|
      s.gsub! /cpp/, "/usr/bin/cpp"
    end
    
    inreplace "xcf2png.c" do |s|
      s.gsub! /png_voidp_NULL/, "NULL"
      s.gsub! /png_error_ptr_NULL/, "NULL"
    end
    
    inreplace "io-unix.c" do |s|
      s.gsub! /"zcat"/, "\"gzcat\""
    end    
    
    bin.mkpath
    man.mkpath
    man1.mkpath
    
    system "./configure", "--enable-precomputed-scaletable", "--disable-rpath", "--prefix=#{prefix}"
    system "make all"
    if build.include? 'run-tests'
      system "make check"
    end
    system "make install"
  end
end
