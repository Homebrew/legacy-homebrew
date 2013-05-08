require 'formula'

class Byobu < Formula
  homepage 'http://byobu.co'
  url 'https://launchpad.net/byobu/trunk/5.39/+download/byobu_5.39.orig.tar.gz'
  sha1 '65b22a3c6bfa7e6a7ddb6838fc95dcb217522493'

  depends_on 'coreutils'
  depends_on 'gnu-sed' # fails with BSD sed
  depends_on 'tmux'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=$(brew --prefix)
    EOS
  end
end
