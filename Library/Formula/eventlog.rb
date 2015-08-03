class Eventlog < Formula
  desc "Replacement for syslog API providing structure to messages"
  homepage "http://www.balabit.com/downloads/files/eventlog/"
  url "http://www.balabit.com/downloads/files/syslog-ng/sources/3.4.3/source/eventlog_0.2.13.tar.gz"
  sha256 "7cb4e6f316daede4fa54547371d5c986395177c12dbdec74a66298e684ac8b85"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
