require 'formula'

class Gshhs < Formula
  url 'ftp://ftp.soest.hawaii.edu/gmt/gshhs-2.2.0.tar.bz2'
  homepage 'http://gmt.soest.hawaii.edu/'
  md5 'db98bff37adc0d51fdf0ffa3834d45ad'
end

class Gmt < Formula
  url 'ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.7.tar.bz2'
  homepage 'http://gmt.soest.hawaii.edu/'
  md5 'fc8a4a546ff8572c225aa7bdb56bbdf8'

  depends_on 'netcdf'

  def install
    # we need -j1 to prevent make dependency errors
    ENV.j1

    system "./configure", "--datadir=#{share}/#{name}",
                          "--enable-netcdf=#{HOMEBREW_PREFIX}",
                          "--enable-shared", "--enable-triangle",
                          "--disable-xgrid", "--disable-mex",
                          "--prefix=#{prefix}"
    system "make"
    system "make install-gmt"
    system "make install-data"
    system "make install-suppl"
    system "make install-man"

    Gshhs.new.brew { (share+name).install Dir['share/*'] }
  end
end
