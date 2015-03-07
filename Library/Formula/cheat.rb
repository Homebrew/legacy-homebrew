class Cheat < Formula
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.1.7.tar.gz"
  sha1 "ab61a6df220df76d1819db04d79e06a3d49768f1"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any
    sha1 "489836b136a52aa064cf641c518fc0818bf0567c" => :yosemite
    sha1 "326a16552272135d92ca3792acddeca5748c1d9c" => :mavericks
    sha1 "10d3ec04f8eaa4978cf3fe0a9d178741c1f926b7" => :mountain_lion
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
