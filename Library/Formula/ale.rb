class Ale < Formula
  homepage "https://darker0n.github.io/ale"
  url "https://github.com/darker0n/ale/archive/v0.1.1.tar.gz"
  version "0.1.1"
  sha256 "2bae9392f02dc6fc1a77c637fa0139a26648b0303a63eae9b46661999985c679"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec

    libexec.install Dir["core"]
    bin.install "ale.py"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    system "python", "setup.py", "install", "--user"
    system "alias", "ale=\"#{prefix}/bin/ale.py\""
  end
end
