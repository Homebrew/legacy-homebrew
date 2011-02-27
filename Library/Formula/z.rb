require 'formula'

class Z <Formula
  url 'https://github.com/rupa/z/tarball/v1.0'
  head 'git://github.com/rupa/z.git'
  homepage 'https://github.com/rupa/z'
  version '1.0'
  sha1 'a4b87c24aaec0a8f69e8ea50d1026347b75b0a9c'

  def install
    (prefix+'etc/profile.d').install('z.sh')
    man1.install('z.1')
  end

  def caveats
    <<-EOS.undent
    Put something like this in your $HOME/.bashrc:

     . `brew --prefix`/etc/profile.d/z.sh

    Put something like this in your $HOME/.zshrc:

     . `brew --prefix`/etc/profile.d/z.sh
     function precmd () {
       z --add "$(pwd -P)"
     }
    EOS
  end
end

