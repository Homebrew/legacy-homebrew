require 'formula'

class PureFtpd < Formula
  url 'http://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.35.tar.gz'
  homepage 'http://www.pureftpd.org/project/pure-ftpd'
  md5 'fa53507ff8e9fdca0197917ec8d106a3'

  def options
    [
      ['--with-mysql', "Enable MySQL authentication support"],
      ['--with-pgsql', "Enable PostgreSQL authentication support"]
    ]
  end

  depends_on 'mysql' if ARGV.include? '--with-mysql'
  depends_on 'postgresql' if ARGV.include? '--with-pgsql'

  def install
    args = ["--with-altlog", "--with-puredb", "--with-extauth", "--with-pam",
            "--with-cookie", "--with-throttling", "--with-ratios", "--with-quotas",
            "--with-ftpwho", "--with-virtualhosts", "--with-virtualchroot", "--with-ldap",
            "--with-diraliases", "--with-nonroot", "--with-peruserlimits", "--with-tls",
            "--with-everything", "--with-rfc2640", "--with-bonjour", "--prefix=#{prefix}"]
    args << "--with-mysql" if ARGV.include? '--with-mysql'
    args << "--with-pgsql" if ARGV.include? '--with-pgsql'
    system "./configure", args
    system "make"
    system "make install-strip"
  end

  def test
    system "pure-ftpd -h"
  end
end
