require 'formula'

class Connect < Formula
  homepage 'https://github.com/anthonygreen/connect.c'
  url 'https://raw.githubusercontent.com/anthonygreen/connect.c/master/connect.c'
  version '1.100'
  sha1 '39614dfa842514f46bdb6ff66a10d2f5b084234f'

  def install
    system ENV.cc, "connect.c", "-o", "connect", "-lresolv"
    bin.install "connect"
  end
end
