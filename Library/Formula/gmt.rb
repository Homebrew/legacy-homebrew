require 'formula'

def with_gdal?; ARGV.include? '--with-gdal'; end

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
  if with_gdal?
    depends_on 'gdal'
  end

  def install
    # we need to deparallelize to prevent make dependency errors
    ENV.deparallelize

    args = ["--prefix=#{prefix}",
            "--datadir=#{share}/#{name}",
            "--enable-netcdf=#{HOMEBREW_PREFIX}",
            "--enable-shared", "--enable-triangle",
            "--disable-xgrid", "--disable-mex"]

    if with_gdal?
        args << "--enable-gdal=#{HOMEBREW_PREFIX}"
    end

    system "./configure", *args
    system "make"
    system "make install-gmt"
    system "make install-data"

    Gshhs.new.brew { (share+name).install Dir['share/*'] }
  end
end
