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
    sha1 "efec08e9b471b9502b1db4dbc4ef855409b24c1e"
  end

  patch do
    url "https://github.com/wdas/partio/commit/bdce60e316b699fb4fd813c6cad9d369205657c8.diff"
    sha1 "030afc6a773d395f1d2168ed3871b9b931874da1"
  end

  patch do
    url "https://github.com/wdas/partio/commit/e557c212b0e8e0c4830e7991541686d568853afd.diff"
    sha1 "7d319a880b8640d8f64afd74f3c2fe86eab1bb1f"
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
