require "formula"

class Xdu < Formula
  homepage "http://sd.wareonearth.com/~phil/xdu/"
  url "http://sd.wareonearth.com/~phil/xdu/xdu-3.0.tar.Z"
  sha1 "196e2ba03253fd6b8a88fafe6b00e40632183d0c"

  depends_on :x11

  def install
    ENV.append_to_cflags "-I#{MacOS::X11.include}"
    ENV.append_to_cflags "-Wno-return-type"
    ENV.append "LDFLAGS", "-L#{MacOS::X11.lib}"

    system "#{ENV.cc} -o xdu #{ENV.cflags} #{ENV.ldflags} -lXaw -lXmu -lXt -lSM -lICE -lXpm -lXext -lX11 xdu.c xwin.c"
    bin.install "xdu"
    man1.install "xdu.man" => "xdu.1x"
    (etc/"X11/app-defaults").install "XDu.ad" => "XDu"
  end
end
