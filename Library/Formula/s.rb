require 'formula'

class S < Formula
  homepage 'https://github.com/haosdent/s'
  url 'https://github.com/haosdent/s/archive/v1.0.tar.gz'
  sha1 '081f81da91176d2729953631d502faf6726bf0c6'

  head 'https://github.com/haosdent/s.git'

  def install
    (prefix/'etc/profile.d').install 's.sh'
    man1.install 's.1'
  end

  def caveats; <<-EOS.undent
    For Bash or Zsh, put something like this in your $HOME/.bashrc or $HOME/.zshrc:
      . `brew --prefix`/etc/profile.d/s.sh
    EOS
  end
end