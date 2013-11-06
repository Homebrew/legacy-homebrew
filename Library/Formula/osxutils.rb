require 'formula'

class Osxutils < Formula
  homepage 'https://github.com/vasi/osxutils'
  head 'https://github.com/vasi/osxutils.git'
  url 'https://github.com/vasi/osxutils/archive/v1.8.tar.gz'
  sha1 'c3d20da36ecfae3abff07f482a572b3680a12b6d'

  conflicts_with 'trash', :because => 'both install a trash binary'
  conflicts_with 'leptonica',
    :because => "both leptonica and osxutils ship a `fileinfo` executable."

  def install
    system 'make'
    system 'make', "PREFIX=#{prefix}", 'install'
  end
end
