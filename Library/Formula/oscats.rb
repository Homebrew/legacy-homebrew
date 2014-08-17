require 'formula'

class Oscats < Formula
  homepage 'http://code.google.com/p/oscats/'
  url 'https://oscats.googlecode.com/files/oscats-0.6.tar.gz'
  sha1 'f57fa06ee0d842ed4c547dd7ab599fd5090d7550'

  depends_on 'pkg-config' => :build
  depends_on :python => :optional
  depends_on 'gsl'
  depends_on 'glib'
  depends_on 'pygobject' if build.with? 'python'

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-python-bindings" if build.with? 'python'
    system "./configure", *args
    system "make install"
  end
end
