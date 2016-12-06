require 'formula'

class Jq < Formula
  homepage 'http://stedolan.github.com/jq/'
  url 'http://stedolan.github.com/jq/download/source/jq.tgz'
  sha1 '5f5c79088bc8f423a25cd52c8973e396f8416979'

  version '1.1'

  def install
    system "make jq"
    system "install -d -m 0755 #{bin}"
    system "install -m 0755 jq #{bin}"
  end

  def test
    system "echo '{}' | jq"
  end
end
