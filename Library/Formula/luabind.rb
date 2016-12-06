require 'formula'

class Luabind < Formula
  homepage 'http://www.rasterbar.com/products/luabind.html'
  url 'https://github.com/luabind/luabind/zipball/v0.9.1'
  sha1 '8b073335a8e6e19acc2bdb7d5b22dc9cc36a3090'

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
