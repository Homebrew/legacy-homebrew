class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.17.0.tar.gz"
  sha256 "7670686cd3bf73b787d4f71b854f528bc7245ab2f740d2806ef0b8d9155f7476"

  bottle do
    cellar :any_skip_relocation
    sha256 "22425ee9bec8269a44a80eefaa2b9d70852a5bacc34e6a49c57212fb40160688" => :el_capitan
    sha256 "27b64e956363db52fb136c3f7a4ca082999fe3a1fa1ce0d125aea54d73bed75e" => :yosemite
    sha256 "a037a9ba19e3740bcb43023d4363864cde664178f46942ddff5a194bac43f6cc" => :mavericks
  end

  depends_on "elixir" => :build
  depends_on "node" => :build

  def install
    ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"

    system "mix", "local.hex", "--force"
    system "mix", "deps.get"
    system "npm", "install"
    system "mix", "std_lib"
    system "mix", "clean"
    system "mix", "compile"
    system "mix", "dist"
    bin.install "elixirscript"
    prefix.install Dir["priv/*"], "LICENSE"
  end

  test do
    src_path = testpath/"Example.exjs"
    src_path.write <<-EOS.undent
      :keith
    EOS

    out_path = testpath/"dest"
    system "elixirscript", src_path, "-o", out_path

    assert File.exist?(out_path)
    assert_match("keith", (out_path/"Elixir.ElixirScript.Temp.js").read)
  end
end
