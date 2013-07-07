require 'formula'

class Eventlog < Formula
  homepage 'http://www.balabit.com/downloads/files/eventlog/'
  url 'http://www.balabit.com/downloads/files/eventlog/0.2/eventlog_0.2.12.tar.gz'
  sha1 '3e35a634e7de029ab9d36995a085bfcb00ed6a4d'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
