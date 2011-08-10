require 'formula'

class Dzen2 < Formula
  url 'http://sites.google.com/site/gotmor/dzen2-0.8.5.tar.gz'
  homepage 'http://sites.google.com/site/gotmor/dzen'
  md5 '5978620c2124c8a8ad52d7f17ce94fd7'

  def install
    ENV.x11
    ENV.append 'LDFLAGS', '-lX11 -lXinerama -lXpm'
    ENV.append_to_cflags '-DVERSION=\"${VERSION}\" -DDZEN_XINERAMA -DDZEN_XPM'

    inreplace 'config.mk' do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "LDFLAGS", ENV.ldflags
    end

    system "make install"
  end
end
