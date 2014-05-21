require 'formula'

class Imake < Formula
  homepage 'http://xorg.freedesktop.org'
  url 'http://xorg.freedesktop.org/releases/individual/util/imake-1.0.6.tar.bz2'
  sha1 'a54c025d7ac9894b6bc919d13454c6adb12ae140'

  depends_on 'pkg-config' => :build
  depends_on :x11

  resource 'xorg-cf-files' do
    url 'http://xorg.freedesktop.org/releases/individual/util/xorg-cf-files-1.0.5.tar.bz2'
    sha1 'ae22eb81d56d018f0b3b149f70965ebfef2385fd'
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"

    resource('xorg-cf-files').stage do
      # Fix for different X11 locations.
      inreplace "X11.rules", "define TopXInclude	/**/",
                "define TopXInclude	-I#{MacOS::X11.include}"
      system "./configure", "--with-config-dir=#{lib}/X11/config",
                            "--prefix=#{HOMEBREW_PREFIX}"
      system "make install"
    end
  end
end
