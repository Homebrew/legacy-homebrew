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
    { :p1 => "https://gist.github.com/raw/2838711/eb2bc8538ae92e33075b08867975167316d72cc2/ipmitool-1.8.11-99.dell.patch" } if ARGV.include? '--with-delloem'
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}",
                          "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
