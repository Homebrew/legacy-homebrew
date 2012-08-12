require 'formula'

class Rsyslog < Formula
  url 'http://rsyslog.com/files/download/rsyslog/rsyslog-5.8.0.tar.gz'
  homepage 'http://www.rsyslog.com'
  md5 '37562d0e71a24938a9ed7f242bd32d35'

  depends_on 'pkg-config' => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
