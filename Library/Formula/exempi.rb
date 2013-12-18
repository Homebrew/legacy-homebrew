require 'formula'

class Exempi < Formula
  homepage 'http://libopenraw.freedesktop.org/wiki/Exempi'
  url 'http://libopenraw.freedesktop.org/download/exempi-2.2.0.tar.bz2'
  sha1 '8c90ee42fef86890e4850c3562f8044f9cd66cfb'

  depends_on 'boost'

  def patches
    [
      # Exempi 2.2.0's Mac-specific file handling code fails semi-randomly
      # This patch is in the upstream git repo & should be in next version
      "http://cgit.freedesktop.org/exempi/patch/?id=720fdbc86b625a45dd28226f829be0764b8ebc58",
      # Fixes headers which fail on Xcode >= 4.3
      # Merged upstream, should be in next version
      "https://bugs.freedesktop.org/attachment.cgi?id=72819"
    ]
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-boost=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
