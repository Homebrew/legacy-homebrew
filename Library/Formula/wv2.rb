require 'formula'

class Wv2 < Formula
  url 'http://downloads.sourceforge.net/project/wvware/wv2-0.4.2.tar.bz2'
  homepage 'http://wvware.sourceforge.net/'
  md5 '850ed8e44a84e7bf0610747827018cbc'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libgsf'

  def install
    ENV.append 'LDFLAGS', '-liconv -lgobject-2.0' # work around broken detection
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
