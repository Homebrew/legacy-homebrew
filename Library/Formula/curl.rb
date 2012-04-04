require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.24.0.tar.bz2'
  sha256 'ebdb111088ff8b0e05b1d1b075e9f1608285e8105cc51e21caacf33d01812c16'

  keg_only :provided_by_osx,
            "The libcurl provided by Leopard is too old for CouchDB to use."

  depends_on 'libssh2' if ARGV.include? "--with-ssh"

  def options
  [
    ["--with-ssh", "build with scp and sftp support."],
  ]
  end

  def install
    if ARGV.include? "--with-ssh" then
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--with-ssl", "--with-libssh2",
                            "--prefix=#{prefix}"
    else
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
    end
    system "make install"
  end
end
