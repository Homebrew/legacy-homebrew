class EyeD3 < Formula
  desc "Work with ID3 metadata in .mp3 files"
  homepage "http://eyed3.nicfit.net/"
  url "http://eyed3.nicfit.net/releases/eyeD3-0.7.8.tar.gz"
  sha256 "06b956572b8d63c52db8f62447277a5647fc185b7afef9f2a918b4601db467db"

  bottle do
    cellar :any_skip_relocation
    sha256 "acfb35d236229963feeed7e2ad301c96dbcc381d5320e4346b3da44cb35c7b6a" => :el_capitan
    sha256 "a79293b1de717fa855e7adfbadb4570a52331f8ef6297f7f1b8a514edd1eea10" => :yosemite
    sha256 "1ed297626268da26de4ca3b1f4e1a2bb6302b1dc7716271775070a6660eb6142" => :mavericks
    sha256 "68c255648b6bca4542ee041122e96f276611cdc3785a4016c658c61d877d9419" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  # Looking for documentation? Please submit a PR to build some!
  # See https://github.com/Homebrew/homebrew/issues/32770 for previous attempt.

  def install
    # Install in our prefix, not the first-in-the-path python site-packages dir.
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{libexec}"
    share.install "docs/plugins", "docs/api", "docs/cli.rst"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    touch "temp.mp3"
    system "#{bin}/eyeD3", "-a", "HomebrewYo", "-n", "37", "temp.mp3"
  end
end
