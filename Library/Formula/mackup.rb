require 'formula'

class Mackup < Formula
  homepage 'https://github.com/lra/mackup'
  url 'https://raw.github.com/lra/mackup/0.3.2/mackup.py'
  sha1 'ab158808d9443847274d38b995e9bb55f5bcb92a'
  version '0.3.2'

  def install
    bin.install "mackup.py" => "mackup"
  end
end
