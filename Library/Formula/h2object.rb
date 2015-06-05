require 'formula'

class H2object < Formula
  homepage 'http://h2object.io'
  url 'http://dl.h2object.io/h2object/version/h2object-0.0.1-beta.tar.gz'
  sha1 'b4a5ff6edab956df4128c3bab75b45dbbec125f2'

  def install
    bin.install 'h2object'
  end
end

