require 'formula'

class HashRing < Formula
  homepage 'https://github.com/chrismoos/hash-ring'
  url 'https://github.com/chrismoos/hash-ring/zipball/v1.0.0'
  md5 '3e7837f14850fc40f02e223e5efd2d00'
  version '1.0.0'

  def install
    system "make prefix=#{prefix} install"
  end
end
