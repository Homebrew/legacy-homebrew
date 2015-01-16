class Cheat < Formula
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.1.3.tar.gz"
  sha1 "968c6f88181af37e9cdb7e93e46b97c935c864d1"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any
    sha1 "21368d2e4f0394e461c473a637be57c0eb1a17c4" => :yosemite
    sha1 "c117c796c2be0b330ee3b91acc03a73ad14f9a79" => :mavericks
    sha1 "7e889187dcef76f9ee8df1c581bb003a14abf8de" => :mountain_lion
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
