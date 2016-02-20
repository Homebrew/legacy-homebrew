class Mps < Formula
  desc "Terminal based MP3 search, playback and download"
  homepage "https://github.com/np1/mps"
  url "https://github.com/np1/mps/archive/v0.20.16.tar.gz"
  sha256 "23542f7dc7ae418ff41ea86debedfe5051d47efec3d0bc170ad0d59b5ec668d0"

  depends_on "mplayer"
  depends_on :python3

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python3.5/site-packages"
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "mps", "top" # Lists top tracks
  end
end
