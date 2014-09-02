require "formula"

class ApacheKaraf < Formula
  homepage "http://karaf.apache.org"
  url "http://mirror.cogentco.com/pub/apache/karaf/2.3.6/apache-karaf-2.3.6.tar.gz"
  sha1 "9a54171ade3c3722a8385b916d9904038af8c13d"

  def install
    libexec.install "bin", "data", "demos", "deploy", "etc", "lib", "system"

    bin.env_script_all_files(libexec + 'bin', :KARAF_HOME => libexec)
  end

  test do
      system bin/admin
  end
end
