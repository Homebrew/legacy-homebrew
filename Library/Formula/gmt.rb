require 'formula'

class Gshhs < Formula
  homepage 'http://gmt.soest.hawaii.edu/'
  url 'ftp://ftp.soest.hawaii.edu/gmt/gshhs-2.2.0.tar.bz2'
  md5 'db98bff37adc0d51fdf0ffa3834d45ad'
end

class Gmt < Formula
  homepage 'http://gmt.soest.hawaii.edu/'
  url 'ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.8.tar.bz2'
  md5 '8a3fa928bcb8a82ebaed68d62ba8f1ba'

  depends_on 'gdal'
  depends_on 'netcdf'

  def install
    ENV.deparallelize # Parallel builds don't work due to missing makefile dependencies

    system "./configure", "--prefix=#{prefix}",
                          "--datadir=#{share}/#{name}",
                          "--enable-gdal=#{HOMEBREW_PREFIX}",
                          "--enable-netcdf=#{HOMEBREW_PREFIX}",
                          "--enable-shared",
                          "--enable-triangle",
                          "--disable-xgrid",
                          "--disable-mex"
    system "make"
    system "make install-gmt"
    system "make install-data"
    system "make install-suppl"
    system "make install-man"

    Gshhs.new.brew { (share+name).install Dir['share/*'] }
  end
end
