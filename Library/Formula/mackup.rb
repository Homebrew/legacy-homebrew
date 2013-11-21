require 'formula'

class Mackup < Formula
  homepage 'https://github.com/lra/mackup'
  url 'https://github.com/lra/mackup/archive/0.5.2.tar.gz'
  sha1 '4b5fcd010f256dd8c67fe7a6ed9da2b77d162d09'

  def install
    bin.install "mackup.py" => "mackup"
    (share/'mackup').install ".mackup.cfg" => "mackup.cfg.example"
  end
end
