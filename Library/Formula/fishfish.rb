require 'formula'

class Fishfish < Formula
  homepage 'http://ridiculousfish.com/shell'

  url 'https://github.com/fish-shell/fish-shell.git',
      :tag => 'OpenBeta_r2'
  version 'OpenBeta_r2'

  head 'https://github.com/fish-shell/fish-shell.git',
       :branch => 'master'

  depends_on :autoconf
  depends_on 'doxygen' => :build

  conflicts_with "fish"

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--without-xsel"
    system "make install"
  end

  def test
    system "fish -c 'echo'"
  end

  def caveats; <<-EOS.undent
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells. Run:
      chsh -s #{HOMEBREW_PREFIX}/bin/fish
    to make fish your default shell.
    EOS
  end
end
