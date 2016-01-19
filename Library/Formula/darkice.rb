class Darkice < Formula
  desc "Live audio streamer"
  homepage "https://code.google.com/p/darkice/"
  url "https://darkice.googlecode.com/files/darkice-1.2.tar.gz"
  sha256 "b3fba9be2d9c72f36b0659cd9ce0652c8f973b5c6498407f093da9a364fdb254"

  head "http://darkice.googlecode.com/svn/darkice/branches/darkice-macosx"

  depends_on "libvorbis"
  depends_on "lame"
  depends_on "two-lame"
  depends_on "faac"
  depends_on "jack"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lame-prefix=#{HOMEBREW_PREFIX}",
                          "--with-vorbis-prefix=#{HOMEBREW_PREFIX}",
                          "--with-twolame-prefix=#{HOMEBREW_PREFIX}",
                          "--with-faac-prefix=#{HOMEBREW_PREFIX}",
                          "--with-jack-prefix=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
