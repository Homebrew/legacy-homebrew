require 'formula'

class Mackup < Formula
  homepage 'https://github.com/lra/mackup'
  url 'https://raw.github.com/lra/mackup/0.1/mackup.py'
  sha1 '0d83270a6826cca2231b486282be2a0b219a0d78'

  def install
    bin.install "mackup.py" => "mackup"
  end
end
