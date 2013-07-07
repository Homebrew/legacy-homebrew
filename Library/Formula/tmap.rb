require 'formula'

class Tmap < Formula
  homepage 'https://github.com/iontorrent/TMAP'
  url 'https://github.com/iontorrent/TMAP.git', :tag => 'tmap.3.2.0'
  sha1 'da3eb4ce3428cec1f5ac12467af4802df6188711'
  version '3.2.0'

  head 'https://github.com/iontorrent/TMAP.git'

  env :std

  option '32-bit'
  option 'indels',  'Enable adjacent insertion and deletions in the alignment'
  option 'perf',    'Enable google performance tools for profiling and heap checking'
  option 'nocolor', 'Disable terminal coloring'

  depends_on :automake
  depends_on :libtool
  depends_on 'google-perftools' if build.include? 'perf'

  fails_with :clang do
    build 421
    cause 'Missing symbols being discussed in iontorrent/TMAP#3'
  end

  def install
    system 'sh', 'autogen.sh'
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
     ]
    args << '--enable-32bit-support' if build.include? '32-bit' or not MacOS.prefer_64_bit?
    args << '--enable-perftools' if build.include? 'perf'
    args << '--disable-coloring' if build.include? 'nocolor'
    args << '--enable-adjacent-indels' if build.include? 'indels'

    system "./configure", *args
    ENV.j1
    system 'make'
    system "make install"
  end

  def test
    system "#{bin}/tmap", "-v"
  end
end
