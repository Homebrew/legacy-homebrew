require 'formula'

class Cdpr < Formula
  homepage 'http://www.monkeymental.com/'
  url 'http://downloads.sourceforge.net/project/cdpr/cdpr/2.4/cdpr-2.4.tgz'
  sha1 '45cc185ad0eb16178a795a46e676fa698eedb832'

  def install
    # Makefile hardcodes gcc and other atrocities
    system "#{ENV.cc} #{ENV.cflags} cdpr.c cdprs.c conffile.c #{ENV.ldflags} -lpcap -o cdpr"
    bin.install "cdpr"
  end

  def caveats
    "run cdpr sudo'd in order to avoid the error: 'No interfaces found! Make sure pcap is installed.'"
  end
end
