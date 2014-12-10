require 'formula'

class Libqxt < Formula
  homepage 'http://libqxt.org/'
  url 'http://dev.libqxt.org/libqxt/get/v0.6.2.tar.gz'
  sha1 'e72a115895d6469972d3f1464bebeab72c497244'

  bottle do
    revision 1
    sha1 "9067b8aa2d91ea0fd4093db5d7fe95accf51ba41" => :yosemite
    sha1 "6e85849128742e9d76536453fc4f2df435f1e0f2" => :mavericks
    sha1 "14ce9bb17e24f36a53745d5bd4c1b0341fb76e51" => :mountain_lion
  end

  depends_on 'qt'
  depends_on 'berkeley-db' => :optional

  # Patch src/gui/qxtglobalshortcut_mac.cpp to fix a bug caused by obsolete
  # constants in Mac OS X 10.6.
  # http://dev.libqxt.org/libqxt-old-hg/issue/50/
  patch do
    url "https://gist.githubusercontent.com/uranusjr/6019051/raw/866c99ee0031ef2ca7fe6b6495120861d1bd5ec8/qxtglobalshortcut_mac.cpp.diff"
    sha1 "b2e9f4af0f4cc318a053ccf13fc1a6ccbd25cb67"
  end

  def install
    args = ["-prefix", prefix,
            "-libdir", lib,
            "-bindir", bin,
            "-docdir", "#{prefix}/doc",
            "-featuredir", "#{prefix}/features",
            "-release"]
    args << "-no-db" if build.without? 'berkeley-db'

    system "./configure", *args
    system "make"
    system "make install"
  end
end
