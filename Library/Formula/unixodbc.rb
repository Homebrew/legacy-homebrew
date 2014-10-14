require 'formula'

class Unixodbc < Formula
  homepage 'http://www.unixodbc.org/'
  url 'http://www.unixodbc.org/unixODBC-2.3.2.tar.gz'
  mirror 'ftp://mirror.ovh.net/gentoo-distfiles/distfiles/unixODBC-2.3.2.tar.gz'
  sha1 'f84520fd58143625b614fde551435178a558ee2e'
  revision 1

  bottle do
    sha1 "eebb5edaaa4bcd4b2d44c1d6c70fc330f044efcf" => :mavericks
    sha1 "b595c9e8c2f531c0220d0a265a9b021f0d5628bd" => :mountain_lion
    sha1 "e7abdd1023388d5f219d568a091112ac2173889c" => :lion
  end

  option :universal

  conflicts_with 'virtuoso', :because => 'Both install `isql` binaries.'

  keg_only "Shadows system iODBC header files" if MacOS.version < :mavericks

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gui=no"
    system "make install"
  end
end
