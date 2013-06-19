require 'formula'

class Direnv < Formula
  homepage 'http://www.direnv.net'
  url 'https://github.com/zimbatm/direnv/archive/v2.0.0.tar.gz'
  sha1 '0f55ebfba273c81398a787f50c9c37ec463534a6'

  head 'https://github.com/zimbatm/direnv.git'

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
