require "formula"

class EmscriptenLlvmFastcomp < Formula
  homepage "http://emscripten.org"
  url "https://github.com/kripken/emscripten-fastcomp/archive/1.14.1.tar.gz"
  sha1 "84cdc3b8406ab998a9eb6b02e303e8ba4783ef19"

  head "https://github.com/kripken/emscripten-fastcomp.git", :branch => 'incoming'

  resource 'clang' do
     url "https://github.com/kripken/emscripten-fastcomp-clang/archive/1.14.1.tar.gz"
     sha1 "40e74a4d415ff0f882465f24c21e0f0169efd40e"
     #head "https://github.com/kripken/emscripten-fastcomp-clang.git", :branch => 'incoming'
  end

  keg_only "Only required for emscripten"

  def install
    resource('clang').stage do
      (buildpath/'tools/clang').install Dir['*']
    end

    args = [
      "--prefix=#{prefix}",
      "--enable-optimized",
      "--enable-targets=host,js",
      "--disable-assertions",
      "--disable-bindings",
    ]

    system "./configure", *args
    system 'make'
    system 'make', 'install'
  end

  test do
    system "#{bin}/llvm-config", "--version"
  end
end
