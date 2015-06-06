require 'formula'

class H2object < Formula
  homepage 'http://h2object.io'
  url 'http://dl.h2object.io/h2object/macosx/h2object-0.0.1-beta.tar.gz'
  sha1 '588bab3d9372b433d15616a8b8bbe6d2720f27d6'

  def install
    bin.install 'h2object'
  end
end

