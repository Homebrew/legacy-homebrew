require 'formula'

class PureFtpd < Formula
  url 'http://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.32.tar.gz'
  homepage 'http://www.pureftpd.org'
  md5 'a766eb36d537fd30217ffa129eb599b1'

  def options
    [
      ["--with-nonroot", "Allow non-root users to start pure-ftpd"]
    ]
  end

  def install
    compile_args = [
      "--with-everything",
      "--with-pam",
      "--with-privsep",
      "--with-tls",
      "--with-virtualchroot"
    ]
    compile_args << "--with-nonroot" if ARGV.include? "--with-nonroot"

    system "./configure",
      "--prefix=#{prefix}",
      "--sbindir=#{bin}",
      "--sysconfdir=#{etc}",
      "--localstatedir=#{var}",
      *compile_args

    system "make install-strip"
  end
end
