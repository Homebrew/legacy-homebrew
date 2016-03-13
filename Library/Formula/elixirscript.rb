class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.16.0.tar.gz"
  sha256 "1ccc52501be1d762e823c6174aa5db1de200f4edc96b39f1057fa8aefeb6212e"

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
