require 'formula'

class Emboss < Formula
  homepage 'http://emboss.sourceforge.net/'
  url 'ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-6.5.7.tar.gz'
  sha1 '907231eafe07917ae0bf9c5da2e7cdc3e9bae03a'

  option 'without-x', 'Build without X11 support'

  depends_on 'pkg-config' => :build
  depends_on 'libharu'    => :optional
  depends_on 'gd'         => :optional
  depends_on :libpng      => :recommended
  depends_on :x11 unless build.include? 'without-x'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-64
      --with-thread
    ]
    args << '--without-x' if build.include? 'without-x'
    system './configure', *args
    system 'make install'
  end
end
