require 'formula'

class Canything < Formula
  url 'https://github.com/keiji0/canything/archive/0.1.tar.gz'
  sha1 '55a8174d630df0bc6cf3f182cd075c4c0bae6eec'
  homepage 'https://github.com/keiji0/canything'
  version '0.1'

  def install
    system "make"
    system "mkdir -p #{prefix}/bin"
    system "cp LICENSE #{prefix}"
    system "cp README #{prefix}"
    system "mv canything #{prefix}/bin"
  end
end
