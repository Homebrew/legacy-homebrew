require 'formula'

class Dpkt < Formula
  url 'http://dpkt.googlecode.com/files/dpkt-1.7.tar.gz'
  homepage 'http://dpkt.googlecode.com'
  md5 '0baa25fd5d87066cf6189a66cf452ac0'

  # depends_on 'cmake'

  def install
    system "python ./setup.py install"
  end
end
