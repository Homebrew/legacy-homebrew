require 'formula'

class Moreutils < Formula
  homepage 'http://packages.debian.org/unstable/utils/moreutils'
  url 'http://mirrors.kernel.org/debian/pool/main/m/moreutils/moreutils_0.51.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/m/moreutils/moreutils_0.51.tar.gz'
  sha1 '374b8c3bea962bbcde4a8158051c570a1fec6811'

  depends_on "docbook-xsl" => :build

  conflicts_with 'parallel',
    :because => "both install a 'parallel' executable."

  conflicts_with 'task-spooler',
    :because => "both install a 'ts' executable."

  def install
    inreplace "Makefile",
              "/usr/share/xml/docbook/stylesheet/docbook-xsl",
              Formula["docbook-xsl"].opt_prefix/"docbook-xsl"
    system "make", "all"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
