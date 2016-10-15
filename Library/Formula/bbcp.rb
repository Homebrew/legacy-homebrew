class   Bbcp < Formula
  url     "http://www.slac.stanford.edu/~abh/bbcp/bin/x86_darwin_100/bbcp"
  homepage "http://www.slac.stanford.edu/~abh/bbcp/"
  sha256 "cc2477a6e49cd859f14a5bb3ab5a721090273863d453592bf142c060b5e88076"
  version "14.9.2"
  def     install
    bin.install 'bbcp'
  end
  test    do
    system "#{bin}/bbcp", "/dev/zero localhost:/dev/null"
  end
end
