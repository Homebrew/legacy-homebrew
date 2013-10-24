require 'formula'

class Eventlog < Formula
  homepage 'http://www.balabit.com/downloads/files/eventlog/'
  url 'http://www.balabit.com/downloads/files/syslog-ng/sources/3.4.3/source/eventlog_0.2.13.tar.gz'
  sha1 '113e54ef2c4d0d4b23ee65fa502915ceea18b7e6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
