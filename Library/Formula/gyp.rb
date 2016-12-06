require 'formula'

class Gyp < Formula
  homepage 'http://code.google.com/p/gyp/'
  head 'http://gyp.googlecode.com/svn/trunk/'
  version '0.1'

  def install
    system "./setup.py", "build"
    system "./setup.py", "install",
           "--install-scripts=#{bin}",
           "--install-lib=#{bin}/pylib"
  end
end
