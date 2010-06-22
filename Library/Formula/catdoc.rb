require 'formula'

class Catdoc <Formula
  url 'http://ftp.wagner.pp.ru/pub/catdoc/catdoc-0.94.2.tar.gz'
  homepage 'http://wagner.pp.ru/~vitus/software/catdoc/'
  # Victor Wagner publishes a SHA1 hash, to keep it simple let's use that instead of MD5
  sha1 '50ce9d7cb24ad6b10a856c9c24183e2b0a11ca04'

  def install
    system "./configure --disable-debug --disable-dependency-tracking --prefix=#{prefix}"
    # The INSTALL file confuses make on case insensitive filesystems.
    system "mv INSTALL INSTALL.txt"
    system "make"
    # There is a race condition in the charsets/Makefile install target. The following line solves it.
    system "make -C charsets install-dirs"
    system "make install"
  end
end
