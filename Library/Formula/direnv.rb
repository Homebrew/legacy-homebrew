require 'formula'

class Direnv < Formula
  homepage 'http://www.direnv.net'
  url 'https://github.com/zimbatm/direnv/archive/v2.6.0.tar.gz'
  sha1 'ebfa8c087aadeffe2c8f84128082d670d22ea541'

  head 'https://github.com/zimbatm/direnv.git'

  bottle do
    sha1 "fb5340876bc488bd38aba9e00d52fff0f029f797" => :yosemite
    sha1 "fbc2ed0cadad4543df0d09e3afe756866e0e44b3" => :mavericks
    sha1 "353d3f25f0b7e3bd57bc91dd855635163bc426e7" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Finish installation by reading: https://github.com/zimbatm/direnv#setup
    EOS
  end
end
