require 'formula'

def without_imagemagick?
  ARGV.include? '--without-imagemagick'
end

class Autotrace < Formula
  url 'http://downloads.sourceforge.net/project/autotrace/AutoTrace/0.31.1/autotrace-0.31.1.tar.gz'
  homepage 'http://autotrace.sourceforge.net'
  md5 '54eabbb38d2076ded6d271e1ee4d0783'

  depends_on 'imagemagick' unless without_imagemagick?

  def options
    [['--without-imagemagick', 'Compile without ImageMagick (non-bloaty)']]
  end

  def install
    args = [  "--disable-debug",
              "--disable-dependency-tracking",
              "--prefix=#{prefix}",
              "--mandir=#{man}" ]

    args <<  "--without-magick" if without_imagemagick?

    system "./configure", *args
    system "make install"
  end
end
