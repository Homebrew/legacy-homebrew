class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.16.0.tar.gz"
  sha256 "1ccc52501be1d762e823c6174aa5db1de200f4edc96b39f1057fa8aefeb6212e"

  bottle do
    cellar :any_skip_relocation
    sha256 "22425ee9bec8269a44a80eefaa2b9d70852a5bacc34e6a49c57212fb40160688" => :el_capitan
    sha256 "27b64e956363db52fb136c3f7a4ca082999fe3a1fa1ce0d125aea54d73bed75e" => :yosemite
    sha256 "a037a9ba19e3740bcb43023d4363864cde664178f46942ddff5a194bac43f6cc" => :mavericks
  end

  depends_on "elixir" => :build

  def install
    system "mix", "local.hex", "--force"
    system "mix", "deps.get"
    system "mix", "escript.build"
    bin.install "elixirscript"
    prefix.install "priv/Elixir.js", "LICENSE"
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
