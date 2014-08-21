require "formula"

class ApacheKaraf < Formula
  homepage "http://karaf.apache.org"
  url "http://mirror.cogentco.com/pub/apache/karaf/2.3.6/apache-karaf-2.3.6.tar.gz"
  sha1 "9a54171ade3c3722a8385b916d9904038af8c13d"

  keg_only "Karaf divines location of its internal dependencies from the invoked executable's location"

  def install
    libexec.install Dir["bin"]
    libexec.install Dir["data"]
    libexec.install Dir["demos"]
    libexec.install Dir["deploy"]
    libexec.install Dir["etc"]
    libexec.install Dir["lib"]
    libexec.install Dir["system"]
  end

  def caveats;
      msg = <<-EOS.undent
      Set your KARAF_HOME to
          #{prefix}/libexec/
      and then run karaf with
          #{prefix}/libexec/bin/karaf
      EOS
  end
end
