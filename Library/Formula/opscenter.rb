require "formula"

class Opscenter < Formula
  homepage "http://www.datastax.com/docs/opscenter/index"
  url "http://downloads.datastax.com/community/opscenter-5.0.1.tar.gz"
  sha1 "ef23fdf2d4034d43e0397d0598311cfcacf0b1bd"

  depends_on "openssl"

  def install
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]

    bin.write_exec_script libexec/"bin/opscenter"
  end
end
