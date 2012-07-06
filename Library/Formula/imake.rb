require 'formula'

class ImakeXorgCfFiles < Formula
  url 'http://xorg.freedesktop.org/releases/individual/util/xorg-cf-files-1.0.4.tar.bz2'
  sha1 'c58b7252df481572ec1ccd77b9f1ab561ed89e45'
end

class Imake < Formula
  homepage 'http://xorg.freedesktop.org'
  url 'http://xorg.freedesktop.org/releases/individual/util/imake-1.0.5.tar.bz2'
  sha1 '1fd3dca267d125ad86583d7f9663b6ff532cddd1'

  depends_on 'pkg-config' => :build
  depends_on :x11

  def install
    ENV.deparallelize
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
    # install X config files
    ImakeXorgCfFiles.new.brew do
      system "./configure", "--with-config-dir=#{lib}/X11/config"
      system "make install"
    end
  end
end
