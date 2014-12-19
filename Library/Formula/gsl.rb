require 'formula'

class Gsl < Formula
  homepage 'http://www.gnu.org/software/gsl/'
  url 'http://ftpmirror.gnu.org/gsl/gsl-1.16.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gsl/gsl-1.16.tar.gz'
  sha1 '210af9366485f149140973700d90dc93a4b6213e'

  bottle do
    cellar :any
    revision 1
    sha1 "1fe8e32e25366b24b3de3d9ccbf7c72315fc482f" => :yosemite
    sha1 "5763fbd3bde4d3866b44ea19f841b52b271dfc3b" => :mavericks
    sha1 "fecff8034949f3b22782d21b3191826d40bb2e1e" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make install"
  end
end
