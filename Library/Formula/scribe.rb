require 'formula'

# Ideally we'd use original the autotools version https://github.com/facebook/scribe
# However:
# 1) it's broken on automake 1.14 https://github.com/facebook/scribe/pull/75
# 2) has no version zip/tarball for us to use
# 3) depends on fb303, which is not available from the current thrift formular
# The CMake fork however works: https://github.com/onlinecity/scribe

class Scribe < Formula
  homepage 'https://github.com/facebook/scribe'
  url 'https://github.com/onlinecity/scribe/archive/1.5.0.zip'
  sha1 '575ec26a1915a2735c44657845036758d057fa93'
  head 'https://github.com/onlinecity/scribe.git'

  depends_on 'cmake' => :build
  depends_on 'thrift'

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/scribe -h"
  end
end
