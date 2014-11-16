require 'formula'

class Aterm < Formula
  homepage 'http://strategoxt.org/Tools/ATermFormat'
  url 'http://www.meta-environment.org/releases/aterm-2.8.tar.gz'
  sha1 'c9a69db0d0ac58970568f6b46ce96af457d84bcc'

  bottle do
    cellar :any
    sha1 "4854b5dbb4b3823f940687183278bf9eea4314ea" => :mavericks
    sha1 "f8158deddace1854f75723d864a69e51e3fb9c3f" => :mountain_lion
    sha1 "bc701fbb4fac832f2b1662a2d3cab506f6b72798" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    ENV.j1 # Parallel builds don't work
    system "make install"
  end
end
