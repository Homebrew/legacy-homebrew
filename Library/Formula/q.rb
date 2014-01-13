require 'formula'

class Q < Formula
  homepage 'https://github.com/harelba/q'
  url 'https://github.com/harelba/q/archive/1.1.2.tar.gz'
  sha1 '35fbae09322602abf0fd6da26406f0f6bbc7871a'

  def install
    bin.install 'q'
  end
end

