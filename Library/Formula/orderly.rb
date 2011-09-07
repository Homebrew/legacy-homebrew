require 'formula'

class Orderly < Formula
  url 'https://github.com/lloyd/orderly/tarball/cdf140170b987a27826ba146b31890b0ae1506bd'
  homepage 'http://orderly-json.org/'
  md5 'b416de7d7e90088a7c842cc26ae393ec'
  version '0.0.1'

  depends_on 'yajl'
  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
