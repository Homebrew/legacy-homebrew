require "formula"

class Cheat < Formula
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.0.9.tar.gz"
  sha1 "cf4a76badd8d0e58c9299037703ba4abbd2217df"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any
    sha1 "52437406145fdeeb208591fc204c93e2cb9d22ec" => :mavericks
    sha1 "5e3a0e9992dabcdb57ce1987cd7fde79f791664e" => :mountain_lion
    sha1 "cc83ffcefc6e909d50522a8a737721e2b36d4c00" => :lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.1.tar.gz"
    sha1 "3d0ad1cf495d2c801327042e02d67b4ee4b85cd4"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-1.6.tar.gz"
    sha1 "53d831b83b1e4d4f16fec604057e70519f9f02fb"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    bash_completion.install "cheat/autocompletion/cheat.bash"
    zsh_completion.install "cheat/autocompletion/cheat.zsh" => "_cheat"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/cheat", "tar"
  end
end
