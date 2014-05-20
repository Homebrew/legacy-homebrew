require "formula"

class JsonC < Formula
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.11-20130402.tar.gz"
  version "0.11"
  sha1 "1910e10ea57a743ec576688700df4a0cabbe64ba"

  bottle do
    cellar :any
    sha1 "31aab221bbee3c5fb73739a80befc373576ed382" => :mavericks
    sha1 "b37a76d7912266e957d88e3a1fc78a65b852efcd" => :mountain_lion
    sha1 "ee13acb15b713bd2dff8d8c9424e90f7c0a78d6f" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize
    system "make install"
  end
end
