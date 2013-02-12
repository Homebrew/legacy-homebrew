require 'formula'

class Vcsh < Formula
  homepage 'https://github.com/RichiH/vcsh'
  url 'https://github.com/RichiH/vcsh/archive/v1.0-1.tar.gz'
  version '1.0-1'
  sha1 '23a72bc495fce299ee52ac98470f808a0a9a002f'

  depends_on 'mr'

  def install
    bin.install 'vcsh'
  end

  def test
    system "vcsh"
  end
end
