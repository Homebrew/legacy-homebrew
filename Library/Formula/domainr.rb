require 'formula'

class Domainr < Formula
  head 'https://github.com/talsafran/domainr.git'
  homepage 'https://github.com/talsafran/domainr'
  md5 '40ac81ebf4d6aa64b09f4f976b56f1a1'

  def install
    bin.install "domainr"
  end
end
