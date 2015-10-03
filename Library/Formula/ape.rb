class Ape < Formula
  desc "Ajax Push Engine"
  homepage "http://www.ape-project.org/"
  url "https://github.com/APE-Project/APE_Server/archive/v1.1.2.tar.gz"
  sha256 "c5f6ec0740f20dd5eb26c223149fc4bade3daadff02a851e2abb7e00be97db42"

  bottle do
    cellar :any
    sha1 "142d7a4e40a2496c922a5ac0eb1aaeab22b25e70" => :yosemite
    sha1 "db7e3d51666dfe7e9d728c1e37f0f07eb20fc36f" => :mavericks
    sha1 "bc4cdbc2a6212b4070a06c356982a68b1b4f5867" => :mountain_lion
  end

  fails_with :clang do
    build 500
    cause "multiple configure and compile errors"
  end

  def install
    system "./build.sh"
    # The Makefile installs a configuration file in the bindir which our bot red-flags
    (prefix+"etc").mkdir
    inreplace "Makefile", "bin/ape.conf $(bindir)", "bin/ape.conf $(prefix)/etc"
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    The default configuration file is stored in #{etc}. You should load aped with:
      aped --cfg #{etc}/ape.conf
    EOS
  end

  test do
    system "#{bin}/aped", "--version"
  end
end
