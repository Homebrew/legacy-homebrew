require 'formula'

class Liblunar < Formula
  homepage 'http://code.google.com/p/liblunar/'
  url 'http://liblunar.googlecode.com/files/liblunar-2.2.5.tar.gz'
  sha1 'c149dc32776667ed8d53124eec414ab15ace0981'

  option 'python', 'Build python bindings using pygobject'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'glib'
  depends_on 'gettext'
  depends_on 'vala' => :optional
  depends_on 'pygobject' if build.include? 'python'

  def install
    args = %W[
       --disable-dependency-tracking
       --prefix=#{prefix}
    ]
    args << '--disable-python' unless build.include? 'python'
    system './configure', *args
    system 'make install'
  end
end
