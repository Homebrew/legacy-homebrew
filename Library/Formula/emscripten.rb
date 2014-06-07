require "formula"

class Emscripten < Formula
  homepage "http://emscripten.org"
  url "https://github.com/kripken/emscripten/archive/1.16.0.tar.gz"
  sha1 "e23bec39c32eb2ccfe889e320cd8da132a4bbf51"

  head "https://github.com/kripken/emscripten.git", :branch => "incoming"

  bottle do
    sha1 "de4ec1922382233ae5162ebc722e41b5f70ebafd" => :mavericks
    sha1 "49600712bee90639efc17eafb4be8d5c454aa073" => :mountain_lion
    sha1 "ace690ca25a73913df158c5c5d94cb9df8aa9f32" => :lion
  end

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
    # OSX doesn't provide a "python2" binary so use "python" instead.
    python2_shebangs = `grep --recursive --files-with-matches ^#!/usr/bin/.*python2$ #{buildpath}`
    python2_shebang_files = python2_shebangs.lines.sort.uniq
    python2_shebang_files.map! {|f| Pathname(f.chomp)}
    python2_shebang_files.reject! &:symlink?
    inreplace python2_shebang_files, %r{^(#!/usr/bin/.*python)2$}, "\\1"

    # All files from the repository are required as emscripten is a collection
    # of scripts which need to be installed in the same layout as in the Git
    # repository.
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

    %w(em++ em-config emar emcc emconfigure emlink.py emmake
       emranlib emrun emscons).each do |emscript|
      bin.install_symlink libexec/emscript
    end
  end

  test do
    system "#{libexec}/llvm/bin/llvm-config", "--version"
  end

  def caveats; <<-EOS.undent
    Manually set LLVM_ROOT to \"#{opt_prefix}/libexec/llvm/bin\"
    in ~/.emscripten after running `emcc` for the first time.
    EOS
  end
end
