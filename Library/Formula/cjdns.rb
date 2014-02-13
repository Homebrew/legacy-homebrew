require "formula"

class Cjdns < Formula
  homepage "http://cjdns.info"
  version "0.5"
  url "https://github.com/cjdelisle/cjdns/archive/stable-0.5.tar.gz"
  sha1 "7a821f066db143eaf613b85162d83e71e3a890e2"
  head 'https://github.com/cjdelisle/cjdns.git'

  env :std

  def install
    system './do'
    bin.install 'cjdroute'
  end
end
