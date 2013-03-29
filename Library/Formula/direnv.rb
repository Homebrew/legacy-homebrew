require 'formula'

class Direnv < Formula
  homepage 'http://www.direnv.net'
  url 'https://github.com/zimbatm/direnv/archive/v0.1.151.tar.gz'
  sha1 '5cb7487602fa69e1c81e6448aec59336d1537baf'

  head 'https://github.com/zimbatm/direnv.git'

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  def caveats; <<-EOS.undent
    At the END of your ~/.bashrc or ~/.zshrc, add the following line:
      eval `direnv hook $0`

    See the wiki for docs and examples:
      https://github.com/zimbatm/direnv/wiki/
    EOS
  end
end
