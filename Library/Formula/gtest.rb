require 'formula'

class Gtest < Formula
  url 'http://googletest.googlecode.com/files/gtest-1.5.0.tar.gz'
  homepage 'http://code.google.com/p/googletest/'
  md5 '7e27f5f3b79dd1ce9092e159cdbd0635'

  def options
    [
      ["--universal", "Build for both 32 & 64 bit Intel."],
    ]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    # gtest-config tries to be clever in locating libraries, but Homebrew's
    # Cellar confuses it. This lets `gtest-config --libs` work correctly
    inreplace 'scripts/gtest-config', '`dirname $0`', '$bindir'
    system "make install"
  end
end
