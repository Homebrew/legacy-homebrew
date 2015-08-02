require 'formula'

class Vtclock < Formula
  desc "Text-mode fullscreen digital clock"
  homepage 'http://webonastick.com/vtclock/'
  url 'http://webonastick.com/vtclock/vtclock-2005-02-20.tar.gz'
  sha1 'aabc321bd46ceb9015ee5cd84b526487d63f2dc1'

  version '2005-02-20'

  def install
    system "make"
    bin.install "vtclock"
  end

  test do
    system "#{bin}/vtclock -h"
  end
end
