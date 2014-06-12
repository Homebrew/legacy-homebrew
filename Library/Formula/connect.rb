require 'formula'

class Connect < Formula
  homepage 'http://bent.latency.net/bent/git/goto-san-connect-1.85/src/connect.html'
  url 'https://raw.githubusercontent.com/GlennAustin/brew_additions/master/ssh_connect_proxy/connect.c'
  version '1.100'
  sha1 'b6cb36f624ffbfe9ce7b72e5802ad4b13ad2142f'

  def install
    system ENV.cc, "connect.c", "-o", "connect", "-lresolv"
    bin.install "connect"
  end
end
