require 'formula'

class Sixpair < Formula
  homepage 'http://www.pabr.org/sixlinux'
  url 'http://www.pabr.org/sixlinux/sixpair.c'
  sha1 '35219aa4b22bbf34a14cae8791b58c3ee11cc267'
  version '2007-04-18'

  depends_on 'libusb-compat'

  def install
    system "#{ENV.cc} -lusb -o sixpair sixpair.c "
    bin.install("sixpair")
  end

end
