require 'formula'

class Ipmitool < Formula
  homepage 'http://ipmitool.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.12/ipmitool-1.8.12.tar.bz2'
  sha1 'b895564db1196e891b60d2ab4f6d0bf5499c3453'

  def options
    [["--with-delloem", "Include support for \"delloem\" subcommand"]]
  end

  def patches
    # optionally incorporate delloem patches
    { :p1 => "https://gist.github.com/raw/2838711/eb2bc8538ae92e33075b08867975167316d72cc2/ipmitool-1.8.11-99.dell.patch" } if ARGV.include? '--with-delloem'
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
