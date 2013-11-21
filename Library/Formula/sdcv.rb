require 'formula'

class Sdcv < Formula
  homepage 'http://sdcv.sourceforge.net/'
  url 'https://svn.code.sf.net/p/sdcv/code/trunk',
    :using => UnsafeSubversionDownloadStrategy, :revision => '76'
  version '0.5-2013-09-10'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'readline'

  def install
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make", "lang"
      system "make", "install"
    end
  end
end
