require 'formula'

class Luabind < Formula
  homepage 'http://www.rasterbar.com/products/luabind.html'
  url 'http://downloads.sourceforge.net/project/luabind/luabind/0.9.1/luabind-0.9.1.tar.gz'
  sha1 '2e92a18b8156d2e2948951d429cd3482e7347550'

  depends_on 'lua'
  depends_on 'boost'
  depends_on 'boost-build' => :build

  def patches
  [
    # patch Jamroot to perform lookup for shared objects with .dylib suffix
    "https://raw.github.com/gist/3728987/052251fcdc23602770f6c543be9b3e12f0cac50a/Jamroot.diff",
    # apply upstream commit to enable building with clang
    "https://github.com/luabind/luabind/commit/3044a9053ac50977684a75c4af42b2bddb853fad.diff"
  ]
  end

  def install
    args = [
      "release",
      "install"
    ]
    if ENV.compiler == :clang
      args << "--toolset=clang"
    elsif ENV.compiler == :llvm
      args << "--toolset=llvm"
    elsif ENV.compiler == :gcc
      args << "--toolset=darwin"
    end
    args << "--prefix=#{prefix}"
    system "bjam", *args
  end
end
