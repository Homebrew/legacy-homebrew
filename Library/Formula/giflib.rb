require 'formula'

class Giflib < Formula
  desc "GIF library using patented LZW algorithm"
  homepage 'http://giflib.sourceforge.net/'
  # 4.2.0 has breaking API changes; don't update until
  # things in $(brew uses giflib) are compatible
  url 'https://downloads.sourceforge.net/project/giflib/giflib-4.x/giflib-4.2.3.tar.bz2'
  sha256 '0ac8d56726f77c8bc9648c93bbb4d6185d32b15ba7bdb702415990f96f3cb766'

  bottle do
    cellar :any
    sha256 "d51319dcc61c11386ffb963a7d0b3c9c7d4e5d62beb6b863aba9691f56df9132" => :yosemite
    sha256 "bc2e9f9f053b82868f5e3a83be6c8f700141580f3f8b47fa58459721846a6cb2" => :mavericks
    sha256 "d38a310aa80f627a23b65b71e97baf6d08d8daa8281595f523e8116f5d4eace1" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
