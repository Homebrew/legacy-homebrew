require 'formula'

class Nimrod < Formula
  homepage "http://nim-lang.org/"

  url "http://nim-lang.org/download/nim-0.10.2.zip"
  sha1 "0a54d6d7f257cdade5bf950d318066959c48a6dc"

  head "https://github.com/Araq/Nim.git", :branch => "devel"

  bottle do
    cellar :any
    sha1 "3a42be18ae05f497900cba5ba484314c68f62aa1" => :yosemite
    sha1 "f30db501f57632a4872c0dde84a02ff326b58adb" => :mavericks
    sha1 "af153261facdba0a6be325296e82b7c5707ebac6" => :mountain_lion
  end

  def install
    system "/bin/sh", "build.sh"
    system "/bin/sh", "install.sh", prefix

    (prefix/"nim").install "compiler"
    bin.install_symlink prefix/"nim/bin/nim"
    bin.install_symlink prefix/"nim/bin/nim" => "nimrod"
  end

  test do
    (testpath/"hello.nim").write <<-EOS.undent
      echo("Hi!")
    EOS
    system "#{bin}/nim", "compile", "--run", "hello.nim"
  end
end

