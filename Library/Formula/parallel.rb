require "formula"

class Parallel < Formula
  homepage "http://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20140822.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/parallel/parallel-20140822.tar.bz2"
  sha256 "8a146a59bc71218921d561f2c801b85e06fe3a21571083b58e6e0966dd397fd4"

  bottle do
    sha1 "54069a978ae98bb32cd27cabb92bd4d54f83d65d" => :mavericks
    sha1 "9ee4590045684e5e29fb341f496bea5ec732f23e" => :mountain_lion
    sha1 "aad86080cc2d9ae2f4e9db3f765672334eca3802" => :lion
  end

  conflicts_with "moreutils",
    :because => "both install a 'parallel' executable. See the --without-parallel option for 'moreutils'"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
