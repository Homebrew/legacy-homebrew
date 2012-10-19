require 'formula'

class Rsyslog < Formula
  url 'http://rsyslog.com/files/download/rsyslog/rsyslog-5.8.0.tar.gz'
  homepage 'http://www.rsyslog.com'
  sha1 '5a64f0ca8b6d5b32db1c20d46965803a2d8d047a'

  depends_on 'pkg-config' => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
