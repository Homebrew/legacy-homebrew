require "formula"

class Cjdns < Formula
  homepage "http://cjdns.info"
  version "stable-0.5"
  url "https://github.com/cjdelisle/cjdns/archive/stable-0.5.tar.gz"
  head "https://github.com/cjdelisle/cjdns.git"
  sha1 "7a821f066db143eaf613b85162d83e71e3a890e2"

  depends_on "node"

  def install
  	opoo 'If installation fails, try reinstalling with flag "--env=std".'
    system "./do"
    bin.install('cjdroute')
    ohai 'Type "cjdroute" to get started.'
  end
end
