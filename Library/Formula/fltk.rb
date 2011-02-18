require 'formula'

class Fltk < Formula
  url 'http://ftp2.easysw.com/pub/fltk/1.1.10/fltk-1.1.10-source.tar.gz'
  homepage 'http://www.fltk.org/'
  head 'http://ftp.easysw.com/pub/fltk/snapshots/fltk-1.3.x-r8411.tar.bz2'
  if ARGV.build_head?
    md5 '0c44ccd5d9b86c7afb2f402d5e0b56db'
    depends_on 'jpeg'
  else
    md5 'e6378a76ca1ef073bcb092df1ef3ba55'
  end

  def install
    if ARGV.build_head?
      ENV.libpng
      system "autoconf"
    end
    system "./configure", "--prefix=#{prefix}", "--enable-threads"
    system "make install"
  end
end
