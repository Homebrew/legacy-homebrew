require 'formula'

class Libqxt < Formula
  homepage 'http://libqxt.org/'
  url 'http://dev.libqxt.org/libqxt/get/v0.6.2.tar.gz'
  sha1 'e72a115895d6469972d3f1464bebeab72c497244'

  depends_on 'qt'
  depends_on 'berkeley-db' => :optional

  def patches
    # Patch src/gui/qxtglobalshortcut_mac.cpp to fix a bug caused by obsolete
    # constants in Mac OS X 10.6.
    # http://dev.libqxt.org/libqxt-old-hg/issue/50/
    "https://gist.github.com/uranusjr/6019051/raw/"
  end

  def install
    args = ["-prefix", prefix,
            "-libdir", lib,
            "-bindir", bin,
            "-docdir", "#{prefix}/doc",
            "-featuredir", "#{prefix}/features",
            "-release"]
    args << "-no-db" unless build.with? 'berkeley-db'

    system "./configure", *args
    system "make"
    system "make install"
  end
end
