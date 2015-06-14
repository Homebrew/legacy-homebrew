require 'formula'

class Dirt < Formula
  desc "Experimental sample playback"
  homepage 'https://github.com/yaxu/Dirt'
  head 'https://github.com/yaxu/Dirt.git'
  url 'https://github.com/yaxu/Dirt/archive/1.0.tar.gz'
  sha1 '853d6a80bf77ebceabd25411ea01568d9acb3362'

  depends_on 'jack'
  depends_on 'liblo'

  def install
    system "make", "DESTDIR=#{prefix}", "install"
  end

  test do
    system "#{bin}/dirt", "-h"
  end
end
