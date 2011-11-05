require 'formula'

class Autojump < Formula
  url 'https://github.com/downloads/joelthelion/autojump/autojump_v17.tar.gz'
  homepage 'https://github.com/joelthelion/autojump/wiki'
  md5 '38f9cf32fc6442d2db82a64086811a2b'

  head 'https://github.com/joelthelion/autojump.git'

  def install
    bin.install "autojump"
    man1.install "autojump.1"

    inreplace "autojump.sh", '/etc/profile.d/', (prefix+'etc/')
    (prefix+'etc').install "autojump.sh" => "autojump"
    (prefix+'etc').install ["autojump.bash", "autojump.zsh"]
  end

  def caveats; <<-EOS.undent
    Add the following lines to your ~/.bash_profile file:
    if [ -f `brew --prefix`/etc/autojump ]; then
      . `brew --prefix`/etc/autojump
    fi
    EOS
  end
end
