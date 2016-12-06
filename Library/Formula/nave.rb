require 'formula'

class Nave < Formula
  homepage 'https://github.com/isaacs/nave'
  url 'https://github.com/isaacs/nave/tarball/v0.3.0'
  sha1 'ee6ae7a676e725c7b8e9788b3b2a00ea2db6dd91'
  version '0.3.0'

  def install
    mv 'nave.sh', 'nave'
    bin.install 'nave'
  end

  def test
    system "nave"
  end

  def caveats
    <<-EOS.undent
      'nave.sh' was renamed to 'nave' for linking.
    EOS
  end
end
