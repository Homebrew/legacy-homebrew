class Itermocil < Formula
  desc "Allows you setup pre-configured layouts of panes in iTerm2."
  homepage "https://github.com/TomAnthony/itermocil"
  url "https://github.com/TomAnthony/itermocil/archive/0.1.8.tar.gz"
  sha256 "6ad203858734ace6ff103b89d3ee54805aeadb94dde78b29dbdb43351b122607"

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resource("PyYAML").stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install "itermocil"
    bin.install "itermocil.py"
    prefix.install "test_layouts/_tiled_4_panes.yml"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    cp "#{prefix}/_tiled_4_panes.yml", "test.yml"
    ENV["EDITOR"] = "cat"
    system "#{bin}/itermocil", "--debug", "--layout", "test.yml"
  end
end
