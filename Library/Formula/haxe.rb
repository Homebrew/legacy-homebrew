require "formula"

class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "http://haxe.org"

  stable do
    url "https://github.com/HaxeFoundation/haxe.git", :tag => "3.2.0", :revision => "77d171b15c94932d265e2a03d476bafc9b3a1894"
  end

  bottle do
    cellar :any
    sha256 "49e090c6d7dd5afb7518ac7c3e70de9abcc42eb6a16c858a02faaa4cc6eb25e2" => :yosemite
    sha256 "a6bcceefac96a3db26d39999940c833daed45e5d93140a6d245428e3a2218a2f" => :mavericks
    sha256 "040bda6d708295debe5ec8753ca700260b284d18a9b81829653904fa131163bd" => :mountain_lion
  end

  head do
    url "https://github.com/HaxeFoundation/haxe.git", :branch => "development"
  end

  depends_on "objective-caml" => :build
  depends_on "camlp4" => :build
  depends_on "neko" => :optional

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    system "make", "OCAMLOPT=ocamlopt.opt"
    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}", "INSTALL_LIB_DIR=#{lib}/haxe"

    # Replace the absolute symlink by a relative one,
    # such that binary package created by homebrew will work in non-/usr/local locations.
    rm bin/"haxe"
    bin.install_symlink lib/"haxe/haxe"
  end

  test do
    ENV["HAXE_STD_PATH"] = "#{HOMEBREW_PREFIX}/lib/haxe/std"
    system "#{bin}/haxe", "-v", "Std"
  end

  def caveats; <<-EOS.undent
    Add the following line to your .bashrc or equivalent:
      export HAXE_STD_PATH="#{HOMEBREW_PREFIX}/lib/haxe/std"
    EOS
  end
end
