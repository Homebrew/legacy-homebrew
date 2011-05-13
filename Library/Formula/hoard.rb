require 'formula'

class Hoard < Formula
  url 'http://www.cs.umass.edu/~emery/hoard/hoard-3.8/source/hoard-38.zip'
  version '3.8'
  homepage 'http://www.hoard.org/'
  md5 '7f57145f77e20bfcf50a2cdb9652b0b9'

  def install
    system "cd src; make macos"
    lib.install 'src/libhoard.dylib'
  end

  def caveats; <<-EOC
  In order to use Hoard, you need to set an environment variable:
  LD_PRELOAD="#{lib}/libhoard.dylib"

  Or:
  LD_PRELOAD="/usr/local/lib/libhoard.dylib"

  See: http://plasma.cs.umass.edu/emery/using-hoard
  EOC
  end

end
