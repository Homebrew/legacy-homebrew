require 'formula'

class Autojump <Formula
  url 'https://github.com/downloads/joelthelion/autojump/autojump_v13.tar.gz'
  homepage 'http://github.com/joelthelion/autojump/wiki'
  md5 '13e4e6173f4ed63b8babb00fcd95f600'
  version '13'

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
