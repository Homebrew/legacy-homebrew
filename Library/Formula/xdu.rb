require "formula"

class Xdu < Formula
  homepage "https://github.com/msvticket/xdu/"
  url "https://github.com/msvticket/xdu/archive/3.1.tar.gz"
  sha1 "f990fdd118a57c49ee97ffec8e7f1af10ebee8ab"

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
