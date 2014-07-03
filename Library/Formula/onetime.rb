require 'formula'

class Onetime < Formula
  homepage 'http://red-bean.com/onetime/'
  url 'http://red-bean.com/onetime/onetime-1.81.tar.gz'
  sha256 '36a83a83ac9f4018278bf48e868af00f3326b853229fae7e43b38d167e628348'

  devel do
    url "https://github.com/kfogel/OneTime/archive/2.0-beta2.tar.gz"
    version "2.0.02"
    sha256 "adf39b670c9066499b8d50c445019f4cca167cdf1fbdbac7e1b779aa75187b44"
  end

  depends_on :python

  def install
    inreplace "Makefile", '$(DESTDIR)/usr/bin/', '$(DESTDIR)/usr/local/Cellar/onetime'
    mkdir "#{bin}"
    system "make"
    system "make install"
    mv "/usr/local/Cellar/onetime/onetime", "#{bin}"
  end
end
