class Cheat < Formula
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.1.2.tar.gz"
  sha1 "68f8120bb3369cb1daf2f84023c212c4777ce8ef"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any
    sha1 "6f98925637992ad9d976aee595a3354c61712a10" => :yosemite
    sha1 "ae00b12b7f7c7556bcfc8f8aebf4a56b00495aa3" => :mavericks
    sha1 "33793a17ec95d635781937658e7a6ec40fb58438" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha1 "224a3ec08b56445a1bd1583aad06b00692671e04"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.1.tar.gz"
    sha1 "b9e9236693ccf6e86414e8578bf8874181f409de"
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
