class Ape < Formula
  desc "Ajax Push Engine"
  homepage "http://www.ape-project.org/"
  url "https://github.com/APE-Project/APE_Server/archive/v1.1.2.tar.gz"
  sha256 "c5f6ec0740f20dd5eb26c223149fc4bade3daadff02a851e2abb7e00be97db42"

  bottle do
    cellar :any_skip_relocation
    sha256 "259b19e211ff6d6ffc376db0b3696a912a6ac48dca83cbcbe525c78e56755c82" => :el_capitan
    sha256 "3859216e566e6faaccc7183d737527dd4785260a698c8344520e7951baebca76" => :yosemite
    sha256 "83c7ef23309dec2e7bd4bec3ae75b6f0e04fcfecbda489c90810b6948eb3bb28" => :mavericks
    sha256 "136d65f58cb956b95a6ccb9517a5affe69c3491d283478708ca88091abb3103f" => :mountain_lion
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
