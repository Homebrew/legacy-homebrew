require 'formula'

class Smartmontools < Formula
  homepage 'http://sourceforge.net/apps/trac/smartmontools/'
  url 'https://downloads.sourceforge.net/project/smartmontools/smartmontools/6.3/smartmontools-6.3.tar.gz'
  sha1 '716c5dc339d408d628c55dbe69028b1561df4c7e'

  bottle do
    sha1 "cf2bcaf04682dbc444735b73a0cbc719871e1951" => :mavericks
    sha1 "4190a244560811958321f66d8b2544d2f1b9b5a8" => :mountain_lion
    sha1 "0e13fe2610864bba50fd3fa540656fb8bbaf506b" => :lion
  end

  def install
    (var/'run').mkpath
    (var/'lib/smartmontools').mkpath

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--enable-drivedb",
                          "--enable-savestates",
                          "--enable-attributelog"
    system "make install"
  end
end
