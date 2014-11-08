require "formula"

class Ape < Formula
  homepage "http://www.ape-project.org/"
  url "https://github.com/APE-Project/APE_Server/archive/v1.1.2.tar.gz"
  sha1 "a2710108c0130fb4c00777ddde238f68aa4bc0e3"

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
