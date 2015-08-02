require 'formula'

class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage 'https://www.smartmontools.org/'
  url 'https://downloads.sourceforge.net/project/smartmontools/smartmontools/6.4/smartmontools-6.4.tar.gz'
  sha1 '855c7d555dd405e5b392b1631dc36dd9632db8b8'

  bottle do
    sha256 "2a653de9d0f41210a9b139f1e70ae561a72fa87727704f944f32dec6356a0fee" => :yosemite
    sha256 "1b74b913314ede83f0597bf6df2b2cb763a1fd03490b07a529892cd36c2720c6" => :mavericks
    sha256 "2b6dadf59bf77a6e711c547405d682b9f0e8af37329fe01d9abdefb3ce41fd7e" => :mountain_lion
  end

  def install
    (var/'run').mkpath
    (var/'lib/smartmontools').mkpath

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--enable-drivedb",
                          "--enable-savestates",
                          "--enable-attributelog"
    system "make install"
  end
end
