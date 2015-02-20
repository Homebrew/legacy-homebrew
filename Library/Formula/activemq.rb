require "formula"

class Activemq < Formula
  homepage "http://activemq.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=/activemq/5.10.2/apache-activemq-5.10.2-bin.tar.gz"
  sha1 "7b5d797abf6d6767d2f5a17935d8cac829d230cd"

  def install
    rm_rf Dir["bin/linux-x86-*"]

    prefix.install_metafiles
    libexec.install Dir["*"]

    bin.write_exec_script libexec/"bin/activemq"
    bin.write_exec_script libexec/"bin/activemq-admin"
  end
end
