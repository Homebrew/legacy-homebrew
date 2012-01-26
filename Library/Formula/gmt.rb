require 'formula'

class Gmt < Formula
  url 'http://www.andrewbarna.org/homebrew/gmt/GMT4.5.7_with_gshhs2.2.0.tbz'
  homepage 'http://gmt.soest.hawaii.edu/'
  md5 '86ccf5cd795dfa2039aba1f4c8c38c52'
  version '4.5.7'

  depends_on 'netcdf'
  if ARGV.include? '--with-gdal'
    depends_on 'gdal'
  end

  def options
    [
      ['--with-gdal', "Compile with experimental gdal support"]
    ]
  end

  def install
    ENV.deparallelize

    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking",
            "--enable-netcdf=#{HOMEBREW_PREFIX}",
            "--mandir=#{man}"]

    if ARGV.include? '--with-gdal'
      args << "--enable-gdal=#{HOMEBREW_PREFIX}"
    end

    system "./configure", *args
    system "make"
    system "make install-gmt"
    system "make install-data"
  end
end
