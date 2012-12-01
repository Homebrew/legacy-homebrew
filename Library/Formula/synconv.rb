require 'formula'

class Synconv < Formula
  homepage 'https://github.com/fernandotcl/synconv'
  head 'https://github.com/fernandotcl/synconv.git'
  url 'https://github.com/downloads/fernandotcl/synconv/synconv-1.1.2.tar.gz'
  sha1 '0ad68f3214425765a7f2f9ee86bee68a911ebfe8'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'taglib'
  depends_on 'flac' => :optional
  depends_on 'lame' => :optional
  depends_on 'vorbis-tools' => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    man1.install "man/synconv.1"
  end
end
