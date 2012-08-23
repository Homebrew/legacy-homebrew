require 'formula'

class Dzen2 < Formula
  url 'http://sites.google.com/site/gotmor/dzen2-0.8.5.tar.gz'
  homepage 'http://sites.google.com/site/gotmor/dzen'
  sha1 '9216163e86e02b2a75de1dfec1954b1058a829e4'

  depends_on :x11

  def install
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
