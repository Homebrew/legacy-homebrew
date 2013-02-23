require 'formula'

class Oscats < Formula
  homepage 'http://code.google.com/p/oscats/'
  url 'http://oscats.googlecode.com/files/oscats-0.6.tar.gz'
  sha1 'f57fa06ee0d842ed4c547dd7ab599fd5090d7550'

  option 'python', 'Build Python bindings'

  depends_on 'pkg-config' => :build
  depends_on 'gsl'
  depends_on 'glib'
  depends_on 'pygobject' if build.include? 'python'

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-python-bindings" if build.include? 'python'
    system "./configure", *args
    system "make install"
  end
end
