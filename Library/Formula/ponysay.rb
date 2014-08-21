require "formula"

class Ponysay < Formula
  homepage "http://erkin.co/ponysay/"
  url "https://github.com/erkin/ponysay/archive/3.0.2.tar.gz"
  sha1 "e152b4ffea3dff8d2ca18ab597344e9b50ab78e6"

  depends_on :python3
  depends_on "coreutils"

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "install"
  end
end
