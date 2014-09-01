require "formula"

class FastDownward < Formula
  homepage "http://fast-downward.org"
  url "http://herry13.github.io/fd/fast-downward-1.0.0.tar.gz"
  sha1 "b84e5e4914a19338be6b5db031b57f80086fd5df"
  version "1.0.0"

  depends_on "gcc" => :build
  depends_on "cmake" => :build
  depends_on "python"
  depends_on "flex" => :build
  depends_on "bison" => :build
  depends_on "gnu-time"
  depends_on "gawk"
  depends_on "coreutils"

  def install
  	#gcc = "/usr/local/bin/g++-4.9"
    gcc = "/usr/local/bin/g++-#{Formula['gcc'].version_suffix}"

    # compile
    system "cd preprocess && make CXX=#{gcc} CC=#{gcc}"
    system "cd search && make CXX=#{gcc} CC=#{gcc}"

    # install
    system "mkdir #{prefix}/{bin,preprocess,search}"
    system "cp bin/* #{prefix}/bin"
    system "cp -r translate #{prefix}"
    system "cp preprocess/preprocess #{prefix}/preprocess/"
    system "cp search/{downward,downward-release,unitcost} #{prefix}/search/"
    system "ln -sf #{prefix}/preprocess/preprocess #{prefix}/bin/fast-downward-preprocess"
    system "ln -sf #{prefix}/search/downward-release #{prefix}/bin/fast-downward-search"
  end

  test do
    system "/usr/bin/file /usr/local/bin/fast-downward"
  end
end
