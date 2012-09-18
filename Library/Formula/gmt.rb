require 'formula'

class Gshhs < Formula
  homepage 'http://gmt.soest.hawaii.edu/'
  url 'ftp://ftp.soest.hawaii.edu/gmt/gshhs-2.2.0.tar.bz2'
  sha1 '786d58b9a335d3bacb37f40f21ee3bfbb424cd10'
end

class Gmt < Formula
  homepage 'http://gmt.soest.hawaii.edu/'
  url 'ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.8.tar.bz2'
  sha1 '823783c1abc9a7e0493c35661e516d4f607fff17'

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
