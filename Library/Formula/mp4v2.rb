require 'formula'

class Mp4v2 < Formula
  url 'http://mp4v2.googlecode.com/files/mp4v2-trunk-r479.tar.bz2'
  homepage 'http://code.google.com/p/mp4v2/'
  sha1 '1999b805d5e66dffbd95ec3a563758650e23bf60'
  version 'r479'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "make install-man"
  end

  def test
    system "#{HOMEBREW_PREFIX}/bin/mp4file --version"
    oh1 "The test was successful."
  end
end
