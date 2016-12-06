require 'formula'

class Mackup < Formula
  homepage 'https://github.com/lra/mackup'
  url 'https://raw.github.com/lra/mackup/0.4.1/mackup.py'
  sha1 'bc0c4e676f6fa4c9f3915fb5683f0e2d998621ad'
  version '0.4.1'

  def install
    bin.install "mackup.py" => "mackup"
  end
end
