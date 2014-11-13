require "formula"

class Valabind < Formula
  homepage "http://radare.org/"
  head "https://github.com/radare/valabind.git"
  url "https://github.com/radare/valabind/archive/0.8.0.tar.gz"
  sha1 "f677110477e14c2e18ac61c56730ab0e51ac450d"

  depends_on "pkg-config" => :build
  depends_on "swig" => :run
  depends_on "vala"

  # Upstream patches to build against vala 0.26
  patch do
    url "https://gist.githubusercontent.com/jacknagel/7deb63f3ebfaaddbdf0d/raw/fb651566528cf997a770fef6546b8ac5d0838fd6/valabind.diff"
    sha1 "dc9de8370913b91b2b50b0284188e209d7d71bcf"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
