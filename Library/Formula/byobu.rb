require 'formula'

class Byobu < Formula
  homepage 'http://byobu.co'
  url 'https://launchpad.net/byobu/trunk/5.43/+download/byobu_5.43.orig.tar.gz'
  sha1 'fd951ca0db7bad74517d5d2539e8736874c117d9'

  depends_on 'coreutils'
  depends_on 'gnu-sed' # fails with BSD sed
  depends_on 'tmux'
  depends_on 'newt' => 'with-python'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=$(brew --prefix)
    EOS
  end

  test do
    system "#{bin}/byobu-config"
  end
end
