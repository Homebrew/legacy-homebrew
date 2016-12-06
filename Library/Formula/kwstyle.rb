require 'formula'

class Kwstyle < Formula
  homepage 'http://public.kitware.com/KWStyle/'
  url 'http://public.kitware.com/KWStyle/download/KWStyle-snapshot-070515.zip'
  sha1 '8e298dad792e443343bc8d1707e3227c3df914e3'

  head 'cvs://:pserver:anoncvs@public.kitware.com:/cvsroot/KWStyle:KWStyle', :using => :cvs

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  test do
    system "#{bin}/KWStyle -V | grep kwsurl"
  end
end
