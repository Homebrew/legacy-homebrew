class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "http://haxe.org"

  stable do
    url "https://github.com/HaxeFoundation/haxe.git", :tag => "3.2.1", :revision => "deab4424399b520750671e51e5f5c2684e942c17"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "131893375697db4a6f747ebec788f9d0d7304b742a3c007f27ea877f561e1e9f" => :el_capitan
    sha256 "104c2a1e9cc5c0d3ca3ee794a4872e8b25107139106f904c2471162ce278474e" => :yosemite
    sha256 "1e4c88518c6747bf86345ac67b2e3e2da5d9f3cea3c3917e8837ac4db2083412" => :mavericks
  end

  head do
    url "https://github.com/HaxeFoundation/haxe.git", :branch => "development"
  end

  depends_on "ocaml" => :build
  depends_on "camlp4" => :build
  depends_on "neko"

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    args = ["OCAMLOPT=ocamlopt.opt"]
    args << "ADD_REVISION=1" if build.head?
    system "make", *args
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
