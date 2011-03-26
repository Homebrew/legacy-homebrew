require 'formula'

class Libcppabi < Formula
  head 'http://home.roadrunner.com/~hinnant/libcppabi.zip'
  homepage ''
  md5 'cc96873d4cd33189d752f8dc155b067c'

  def install
    lib.install 'libc++abi.dylib'
    include.install 'cxxabi.h'
  end
end
