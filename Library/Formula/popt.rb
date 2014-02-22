require 'formula'

class Popt < Formula
  homepage 'http://rpm5.org'
  url 'http://rpm5.org/files/popt/popt-1.16.tar.gz'
  sha1 'cfe94a15a2404db85858a81ff8de27c8ff3e235e'

  bottle do
    sha1 "ab6a9ee02a3e472537170cca2062a7714d1d896d" => :mavericks
    sha1 "ee206729448db1e914db7d2722a0942e4d08a1f4" => :mountain_lion
    sha1 "1f5fdb9324fa0ef2c590e33d119af66eb35d8ba8" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
