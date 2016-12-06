require 'formula'

class TypesafeActivator < Formula
  homepage 'http://typesafe.com/platform/getstarted'
  url 'http://downloads.typesafe.com/typesafe-activator/0.1.3/typesafe-activator-0.1.3.zip'
  sha1 '530c41c791f36194d093bb435bd6557914b9cae2'

  def install
    rm "activator.bat"

    inreplace "activator" do |s|
      s.gsub! /^declare -r activator_home=.*$/, "declare -r activator_home=#{libexec}"
    end

    libexec.install Dir["*"]
    bin.install_symlink libexec/"activator"
  end
end
