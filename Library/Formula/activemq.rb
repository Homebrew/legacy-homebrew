require "formula"

class Activemq < Formula
  homepage "http://activemq.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=/activemq/5.10.1/apache-activemq-5.10.1-bin.tar.gz"
  sha1 "5e62deb1ccd103ec1765f836756a7889f6131ab0"

  def install
    rm_rf Dir["bin/linux-x86-*"] unless OS.linux?

    prefix.install_metafiles
    libexec.install Dir["*"]

    bin.write_exec_script libexec/"bin/activemq"
    bin.write_exec_script libexec/"bin/activemq-admin"
  end
end
