require 'formula'

class Canything < Formula
  homepage 'https://github.com/keiji0/canything'
  url 'https://github.com/keiji0/canything/archive/0.1.tar.gz'
  sha1 '55a8174d630df0bc6cf3f182cd075c4c0bae6eec'

  def install
    system "make"
    bin.install 'canything'
  end
end
