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
    sha1 "4900c1066c954c77f0590d954a6f8a6b77f55cec" => :yosemite
    sha1 "821919f75c26599da246cbed6593f741e6546f18" => :mavericks
    sha1 "ded54061c70ed3c9d01cd566cd570963498595a8" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
