require 'formula'

class Liblunar < Formula
  homepage 'http://code.google.com/p/liblunar/'
  url 'https://liblunar.googlecode.com/files/liblunar-2.2.5.tar.gz'
  sha1 'c149dc32776667ed8d53124eec414ab15ace0981'

  bottle do
    sha1 "4ddd0ce2ddc3bc282393de68bff76d5adb611873" => :mavericks
    sha1 "e7c93c0847db2713d51eb90aa92e5dd5672146d4" => :mountain_lion
    sha1 "f5919e09c5c26813d3757ebe6b4a5e780587de6f" => :lion
  end

  option 'python', 'Build python bindings using pygobject'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'glib'
  depends_on 'gettext'
  depends_on 'vala' => :optional
  depends_on :python => :optional
  depends_on 'pygobject' if build.with? 'python'

  def install
    args = %W[
       --disable-dependency-tracking
       --prefix=#{prefix}
    ]
    args << '--disable-python' if build.without? 'python'
    system './configure', *args
    system 'make install'
  end
end
