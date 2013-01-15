require 'formula'

class Partio < Formula
  homepage 'http://www.partio.us'
  url 'https://github.com/wdas/partio/archive/v1.1.0.tar.gz'
  sha1 '446879b2a01a838ad23eb84c4e6da36c1a315e49'

  depends_on 'cmake' => :build
  depends_on 'swig' => :build
  depends_on 'doxygen' => :build

  # These fixes are upstream and can be removed in the next released version.
  def patches
    [
      "https://github.com/wdas/partio/commit/5b80b00ddedaef9ffed19ea4e6773ed1dc27394e.patch",
      "https://github.com/wdas/partio/commit/bdce60e316b699fb4fd813c6cad9d369205657c8.patch",
      "https://github.com/wdas/partio/commit/e557c212b0e8e0c4830e7991541686d568853afd.patch"
    ]
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
