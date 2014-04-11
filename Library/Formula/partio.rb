require 'formula'

class Partio < Formula
  homepage 'http://www.partio.us'
  url 'https://github.com/wdas/partio/archive/v1.1.0.tar.gz'
  sha1 '446879b2a01a838ad23eb84c4e6da36c1a315e49'

  depends_on 'cmake' => :build
  depends_on 'swig' => :build
  depends_on 'doxygen' => :build

  # These fixes are upstream and can be removed in the next released version.
  patch do
    url "https://github.com/wdas/partio/commit/5b80b00ddedaef9ffed19ea4e6773ed1dc27394e.diff"
    sha1 "3b25c1eba327404ea49c3c6f0d3fe71eb114da7d"
  end

  patch do
    url "https://github.com/wdas/partio/commit/bdce60e316b699fb4fd813c6cad9d369205657c8.diff"
    sha1 "51e83e18323895fd5cf1e8725f67db082d8eaa33"
  end

  patch do
    url "https://github.com/wdas/partio/commit/e557c212b0e8e0c4830e7991541686d568853afd.diff"
    sha1 "a7c7d6a2ab47db1961bdc522e62c99b54b547d02"
  end

  def install
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make doc"
      system "make install"
    end
  end
end
