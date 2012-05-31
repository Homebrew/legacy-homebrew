require 'formula'

class ImakeXorgCfFiles < Formula
  url 'http://xorg.freedesktop.org/releases/individual/util/xorg-cf-files-1.0.4.tar.bz2'
  md5 '700c6d040d36a569e657a3ba5e1d8b24'
end

class Imake < Formula
  url 'http://xorg.freedesktop.org/releases/individual/util/imake-1.0.4.tar.bz2'
  homepage 'http://xorg.freedesktop.org'
  md5 '48133c75bd77c127c7eff122e08ebbf6'

  depends_on 'pkg-config' => :build

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
    # install X config files
    ImakeXorgCfFiles.new.brew do
      system "./configure", "--with-config-dir=#{lib}/X11/config"
      system "make install"
    end
  end
end
