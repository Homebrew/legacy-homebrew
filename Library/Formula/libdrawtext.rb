require 'formula'

class Libdrawtext < Formula
  homepage 'http://nuclear.mutantstargoat.com/sw/libdrawtext/'
  url 'http://nuclear.mutantstargoat.com/sw/libdrawtext/libdrawtext-0.2.1.tar.gz'
  sha1 'dd12c67e7c7898a5941a92d616e9dbbbab4b9a38'
  head 'https://github.com/jtsiomb/libdrawtext.git'

  bottle do
    cellar :any
    sha1 "7affeb228a309ba93ea0a9ea264bbd002bbd7647" => :yosemite
    sha1 "a094e897e81a20ab2c285b63ba6f65cabbe07c7f" => :mavericks
    sha1 "69b89d16fccd84752f9080863f6d5151320c7872" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'freetype'
  depends_on 'glew'

  def install
    system "./configure", "--disable-dbg", "--enable-opt", "--prefix=#{prefix}"
    system "make", "install"
  end
end
