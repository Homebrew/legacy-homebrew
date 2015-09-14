class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.1.14.tar.gz"
  sha256 "cf869df86cf2d3feb0c0f4bd48a4538f517e194a9fd4d4cd22724841d2b3d9ec"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any
    sha256 "d0d8b1cf16aadf7ec1cf437a86f2b96dfba9fec807a126543b49e5763a0dc9a3" => :yosemite
    sha256 "b3438bcbb57c323e5a77e6a66a8f17f0c86294dfb2c094b378be66fc0f2e9331" => :mavericks
    sha256 "435e050b5ce4f69516b29d8c38fb803922ab9b1b2178bd3ac10955a4206bd719" => :mountain_lion
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
