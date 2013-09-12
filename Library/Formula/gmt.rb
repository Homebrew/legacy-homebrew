require 'formula'

class Gmt < Formula
  homepage 'http://gmt.soest.hawaii.edu/'
  url 'ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.9.tar.bz2'
  sha1 '711922fd99dcd47ace522f1e46fcafa5beab8c94'

  depends_on 'gdal'
  depends_on 'netcdf'

  resource 'gshhg' do
    url 'ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-nc4-2.2.2.tar.gz'
    sha1 'f01c322ad1767abf99818c250b1a58b3e2c12e1c'
  end

  def install
    ENV.deparallelize # Parallel builds don't work due to missing makefile dependencies
    datadir = share/name
    system "./configure", "--prefix=#{prefix}",
                          "--datadir=#{datadir}",
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
    datadir.install resource('gshhg')
  end
end
