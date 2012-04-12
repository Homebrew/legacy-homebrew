require 'formula'

class Eventlog < Formula
  url 'http://www.balabit.com/downloads/files/eventlog/0.2/eventlog_0.2.12.tar.gz'
  homepage 'http://www.balabit.com/downloads/files/eventlog/'
  md5 '3d6ebda8a161d36cb40d09328f78786b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
