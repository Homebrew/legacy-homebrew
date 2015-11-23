class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.1.18.tar.gz"
  sha256 "9a1d9843df87aca7ae34f1e1a3b22a87e48532925092ba932d67f42c28b2a3d8"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ff7b383c3c035ed16b0ca7e14ebc29d04673ae6823f390df1a9bc60c26cf18e" => :el_capitan
    sha256 "0841ed43a9f9c8ee6b6048dcc81c832611f7652b18611b60051e79af2fabf4e4" => :yosemite
    sha256 "452437b2068ea3d3227f0f7ab55c5c9615ee8427a1e3b40ed3aec3e2d63e2168" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec) }
    end

    system "python", *Language::Python.setup_install_args(prefix)

    bash_completion.install "cheat/autocompletion/cheat.bash"
    zsh_completion.install "cheat/autocompletion/cheat.zsh" => "_cheat"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/cheat", "tar"
  end
end
