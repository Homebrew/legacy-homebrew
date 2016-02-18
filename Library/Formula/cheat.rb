class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.1.22.tar.gz"
  sha256 "48df9b920260bee35bd5cdde83bb51e958d9278416141a64e1f46a3981ccb454"
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
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.1.1.tar.gz"
    sha256 "2df7d9a85b56e54c7c021dc98fc877bd216ead652c10da170779c004fb59c01b"
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
