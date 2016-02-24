class Libdvbpsi < Formula
  desc "Library to decode/generate MPEG TS and DVB PSI tables"
  homepage "https://www.videolan.org/developers/libdvbpsi.html"
  url "https://download.videolan.org/pub/libdvbpsi/1.3.0/libdvbpsi-1.3.0.tar.bz2"
  sha256 "a2fed1d11980662f919bbd1f29e2462719e0f6227e1a531310bd5a706db0a1fe"

  bottle do
    cellar :any
    sha256 "4a2441b1d7ef602c05e46744a394373de1de33284955c455937b4bbdecddfc89" => :el_capitan
    sha256 "db2d97fb4e3460aa1b44e75af5398c0b9d2d8b860f18cb8a197c18e9e1ec8229" => :yosemite
    sha256 "45af2a1bd8b769216fcff8b5c8c37dd136ab4db99167e46a8371db4880afc2c9" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-release"
    system "make", "install"
  end
end
