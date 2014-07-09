require "formula"

class Realpath < Formula
  homepage "https://github.com/harto/realpath-osx"
  url "https://github.com/harto/realpath-osx/archive/1.0.0.tar.gz"
  sha1 "6b8033d5b3fc06da98a53683a0b9176dcc6a8a71"

	depends_on 'cmake' => :build

  def install
    system "cmake", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}", "."
    system "make"
    system "make", "install"
	end

  test do
    system "#{bin}/realpath ."
  end
end
