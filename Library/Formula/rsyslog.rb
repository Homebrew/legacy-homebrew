require 'formula'

class Rsyslog < Formula
  homepage 'http://www.rsyslog.com'
  url 'http://www.rsyslog.com/files/download/rsyslog/rsyslog-5.10.1.tar.gz'
  sha256 '2f643a2c613d5b09f242affd32a90cf4fb7a9ac4557dc80f218e6f3e5affb4c8'

  depends_on 'pkg-config' => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
