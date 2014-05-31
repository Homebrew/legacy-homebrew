require "formula"

class ScreenfetchC < Formula
    homepage "http://woodruffw.us/realsite/projects/screenfetch-c.html"
    version "1.2"
    url "https://github.com/woodruffw/screenfetch-c/archive/1.2-fix2.tar.gz"
    sha1 "0eee57ecd156ae818efce48f3ca80e706050a8c6"

    def install
        system "make", "osx"
        bin.install "screenfetch-c"
        bin.install "src/detectde"
        bin.install "src/detectwm"
        bin.install "src/detectwmtheme"
        bin.install "src/detectgtk"
        bin.install "src/detectgpu"
        man1.install "manpage/screenfetch-c.1"
    end
end
