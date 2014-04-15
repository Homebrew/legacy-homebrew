require "formula"

class Emscripten < Formula
  homepage "http://emscripten.org"
  url "https://github.com/kripken/emscripten/archive/1.16.0.tar.gz"
  sha1 "e23bec39c32eb2ccfe889e320cd8da132a4bbf51"

  head "https://github.com/kripken/emscripten.git", :branch => "incoming"

  head do
    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp.git", :branch => "incoming"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang.git", :branch => "incoming"
    end
  end

  stable do
    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp/archive/1.16.0.tar.gz"
      sha1 "ca10c5a8059fdd321143d8f10c0810176be3d467"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang/archive/1.16.0.tar.gz"
      sha1 "768a15d3a8cd9e92f87521cadf3e5f63f3e24fa1"
    end
  end

  depends_on "node"
  depends_on "closure-compiler" => :optional
  depends_on "yuicompressor"

  def install
    # note - OS X doesn't provide a python2 binary. Use the default python instead
    system "grep --null -rl '^#!/usr/bin/env python2$' . | xargs -0 sed -i '' 's,^#!/usr/bin/env python2$,#!/usr/bin/env python,'"
    system "grep --null -rl '^#!/usr/bin/python2$' . | xargs -0 sed -i '' 's,^#!/usr/bin/python2$,#!/usr/bin/python,'"

    # Note - as per documentation, _all_ files from the repository are
    # required, as emscripten is just a collection of scripts that need to
    # be installed in exactly the same layout as in the git repo
    libexec.install Dir['*']

    (buildpath/"fastcomp").install resource("fastcomp")
    (buildpath/"fastcomp/tools/clang").install resource("fastcomp-clang")

    args = [
      "--prefix=#{libexec}/llvm",
      "--enable-optimized",
      "--enable-targets=host,js",
      "--disable-assertions",
      "--disable-bindings",
    ]

    cd "fastcomp" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end

    emscripts = %w(em++ em-config emar emcc emconfigure emlink.py emmake emranlib emrun emscons)

    emscripts.each do |emscript|
        bin.install_symlink libexec/emscript
    end
  end

  test do
    # copied from the vanilla llvm formula
    system "#{libexec}/llvm/bin/llvm-config", "--version"
  end

  def caveats; <<-EOS.undent
    Manually set LLVM_ROOT to \"#{opt_prefix}/libexec/llvm/bin\"
    in ~/.emscripten after running emcc for the first time.
    EOS
  end
end
