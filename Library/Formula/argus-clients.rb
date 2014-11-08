require "formula"

class ArgusClients < Formula
  homepage "http://qosient.com/argus/"
  url "http://qosient.com/argus/src/argus-clients-3.0.8.tar.gz"
  sha1 "3b9d764dc067af64670bcd8328d6f48088b9b5ca"

  depends_on "readline" => :recommended
  depends_on "rrdtool" => :recommended

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
