require 'formula'

class Popt < Formula
  desc "Library like getopt(3) with a number of enhancements"
  homepage 'http://rpm5.org'
  url 'http://rpm5.org/files/popt/popt-1.16.tar.gz'
  sha1 'cfe94a15a2404db85858a81ff8de27c8ff3e235e'

  bottle do
    revision 1
    sha1 "20ebf6ad6a0e618c6e14249179ebfaa49ceea1a0" => :yosemite
    sha1 "ffa33727245492f9583a7e6905bbeef7454b96c8" => :mavericks
    sha1 "d4736bc9459f25b0d4c267d364798e6614fbbbda" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
