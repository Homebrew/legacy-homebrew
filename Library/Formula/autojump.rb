require 'formula'

class Autojump <Formula
  url 'https://github.com/downloads/joelthelion/autojump/autojump_v14.tar.gz'
  homepage 'https://github.com/joelthelion/autojump/wiki'
  md5 '7c0a41a2d33aee11a844dc17f7825dc9'
  version '14'

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
