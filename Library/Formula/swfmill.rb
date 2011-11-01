require 'formula'

class Swfmill < Formula
  # Staying on 3.0 until this 3.1 issue is fixed:
  # https://bugs.launchpad.net/swfmill/+bug/611403
  url 'http://swfmill.org/releases/swfmill-0.3.1.tar.gz'
  homepage 'http://swfmill.org'
  md5 '63c0b16eab55c385a47afe3ec5b917b9'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
