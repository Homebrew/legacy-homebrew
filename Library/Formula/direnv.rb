require 'formula'

class Direnv < Formula
  homepage 'http://www.direnv.net'
  url 'https://github.com/zimbatm/direnv/archive/v0.1.154.tar.gz'
  sha1 '86a87d7d3c193666ffde47b1fe52dfb2847786ff'

  head 'https://github.com/zimbatm/direnv.git'

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
