require 'formula'

class Plustache < Formula
  homepage 'https://github.com/mrtazz/plustache'
  url 'https://github.com/mrtazz/plustache/tarball/v0.2.0'
  sha1 '266f95596cfedb0b7415f49871a75ccd7ace67da'

  depends_on 'boost'

  def install
    rake "install", "prefix=#{prefix}"
  end
end
