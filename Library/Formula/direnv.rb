require 'formula'

class Direnv < Formula
  homepage 'http://www.direnv.net'
  url 'https://github.com/zimbatm/direnv/archive/v2.5.0.tar.gz'
  sha1 '48aa6a9dc5748b8043fb6f8ccdc8f3b538301382'

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
    At the END of your ~/.bashrc or ~/.zshrc, add the following line:
      eval "$(direnv hook $0)"

    See the wiki for docs and examples:
      https://github.com/zimbatm/direnv/wiki/
    EOS
  end
end
