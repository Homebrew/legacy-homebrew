require 'formula'

class Libdrawtext < Formula
  homepage 'http://nuclear.mutantstargoat.com/sw/libdrawtext/'
  url 'http://nuclear.mutantstargoat.com/sw/libdrawtext/libdrawtext-0.1.tar.gz'
  sha1 '0d7166bbb1479553abf82b71a56ec565d861fe81'

  bottle do
    cellar :any
    sha1 "598e85bf3fd3df14e212fa1eee9a2f79b570152b" => :mavericks
    sha1 "de5a6352e9b1f0336f439ddaaa6c8f594da429d7" => :mountain_lion
    sha1 "afc5256c5b5594aa08ca5b78d710eb0292081e68" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'freetype'
  depends_on 'glew'

  def install
    system "./configure", "--disable-dbg", "--enable-opt",
           "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
