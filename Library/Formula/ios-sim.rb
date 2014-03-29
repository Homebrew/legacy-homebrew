require 'formula'

class IosSim < Formula
  homepage 'https://github.com/phonegap/ios-sim'
  url 'https://github.com/phonegap/ios-sim/archive/1.9.0.tar.gz'
  sha1 '2ec400711e7a9d33eb5f08c577b47ead1fcdb9cb'
  head 'https://github.com/phonegap/ios-sim.git'

  depends_on :macos => :lion

  def install
    rake "install", "prefix=#{prefix}"
  end
end
