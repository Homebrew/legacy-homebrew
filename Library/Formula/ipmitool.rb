require 'formula'

class Ipmitool < Formula
  url 'http://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.11/ipmitool-1.8.11.tar.bz2'
  homepage 'http://ipmitool.sourceforge.net/'
  md5 '1d0da20add7388d64c549f95538b6858'

  def options
    [["--with-delloem", "Include support for \"delloem\" subcommand"]]
  end

  def patches
    # optionally incorporate delloem patches
    { :p1 => "https://gist.github.com/raw/2838711/dc127edd2ba34e1e801bf2a07afa2e3c81a9817f/ipmitool-1.8.11-delloem.patch" } if ARGV.include? '--with-delloem'
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}",
                          "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
