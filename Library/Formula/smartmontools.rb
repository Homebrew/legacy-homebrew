class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/6.4/smartmontools-6.4.tar.gz"
  sha256 "eab75600c1eda9c34b13097db71138ab376f3dad8a6a4667fb4d1d081feb7a85"

  bottle do
    sha256 "7688aed939c30a6fe5390005579be0a9fa1a02ef699ea0990c708d49da2e3462" => :el_capitan
    sha256 "2a653de9d0f41210a9b139f1e70ae561a72fa87727704f944f32dec6356a0fee" => :yosemite
    sha256 "1b74b913314ede83f0597bf6df2b2cb763a1fd03490b07a529892cd36c2720c6" => :mavericks
    sha256 "2b6dadf59bf77a6e711c547405d682b9f0e8af37329fe01d9abdefb3ce41fd7e" => :mountain_lion
  end

  def install
    (var/"run").mkpath
    (var/"lib/smartmontools").mkpath

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--enable-drivedb",
                          "--enable-savestates",
                          "--enable-attributelog"
    system "make", "install"
  end
end
