require 'formula'

class Bonnie <Formula
  url 'http://www.textuality.com/bonnie/bonnie.tar.gz'
  homepage 'http://www.textuality.com/bonnie/'
  md5 'f61cc061a418c3ae308ae362a1ae6490'
  # no real version numbers
  version '0.1.0'

  def install
    system "make"
    bin.install "Bonnie" => "bonnie"
  end
end
