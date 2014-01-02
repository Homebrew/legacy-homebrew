require 'formula'

class Sxiv < Formula
  homepage 'https://github.com/muennich/sxiv'
  url 'https://github.com/muennich/sxiv/archive/v1.1.1.tar.gz'
  sha1 'a87a6940936cc1d14c54d5ffe7814980b5511f07'

  head 'https://github.com/muennich/sxiv.git'

  depends_on :x11
  depends_on 'imlib2'
  depends_on 'giflib'

  def install
    system "make", "config.h"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/sxiv", "-v"
  end
end
