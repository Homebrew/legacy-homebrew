class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "http://haxe.org"

  stable do
    url "https://github.com/HaxeFoundation/haxe.git", :tag => "3.2.0", :revision => "77d171b15c94932d265e2a03d476bafc9b3a1894"
  end

  bottle do
    cellar :any
    revision 1
    sha256 "faa387523fb8dce6d02a542c1898bc561de08ca48637e95118bf2ac7e072bc95" => :yosemite
    sha256 "64ef064b685f74552860b4d83715b8ddc8d5d0c08ac007d7ca246a4cc9b01ab2" => :mavericks
    sha256 "366600c304bc1a3f2d09a629926e65bde16878cb5b0eb28e5b880773bd595c23" => :mountain_lion
  end

  head do
    url "https://github.com/HaxeFoundation/haxe.git", :branch => "development"
  end

  depends_on "ocaml" => :build
  depends_on "camlp4" => :build
  depends_on "neko" => :optional

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
