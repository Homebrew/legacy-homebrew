class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.1.8.tar.gz"
  sha1 "75176e3f8c75f4a476a7ecb53497e72eceace2e2"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any
    sha256 "bf5a19217cb8918dc4a8b61cd2907cf355f4a6e92ea2c294792fbd64b47dc911" => :yosemite
    sha256 "47840d1b30dab97c409dc2259974973fc3e78ef594c2aa5cce9d7ac70ed105df" => :mavericks
    sha256 "c9975d7b4a4e4c30115b155100513e42a1635d7858589ef834d2f94d61b7a3ff" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha1 "224a3ec08b56445a1bd1583aad06b00692671e04"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha1 "fe2c8178a039b6820a7a86b2132a2626df99c7f8"
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
