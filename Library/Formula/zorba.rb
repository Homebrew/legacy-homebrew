require 'formula'

class Zorba < Formula
  homepage 'http://www.zorba-xquery.com/html/index'
  url 'https://launchpad.net/zorba/trunk/2.2/+download/zorba-2.2.0.tar.gz'
  md5 '83cf9edc4a2068f198ff227d942f6ed5'

  depends_on 'cmake' => :build
  depends_on 'icu4c'
  depends_on 'xerces-c'
  depends_on 'swig' => :build

  def options
    [
      ['--disable-big-integer', 'Use 64-bit instead of arbitrary precision integers for performance']
    ]
  end

  def install
    icu4c = Formula.factory('icu4c')
    # zorba has to be built from a seperate dir, so create one
    mktemp do
      args = std_cmake_parameters.split
      # use ICU4C from keg
      args << "-DICU_INCLUDE_DIR=#{icu4c.include}"
      args << "-DICU_LIBRARY_DIR=#{icu4c.lib}"
      # macos comes with libxslt so we may as well use it
      args << "-DZORBA_XQUERYX=ON"
      args << "-DZORBA_WITH_BIG_INTEGER=OFF" if ARGV.include? '--disable-big-integer'
      system "cmake", buildpath, *args
      system "make install"
    end
  end

  def test
    system "zorba -r -q '1 + 1'"
  end
end
