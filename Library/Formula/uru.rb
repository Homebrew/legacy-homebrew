require 'formula'

class Uru < Formula
  homepage 'https://bitbucket.org/jonforums/uru'
  url 'https://bitbucket.org/jonforums/uru/downloads/uru-0.6.4-darwin-x86.tar.gz'
  version '0.6.4'
  sha1 'fc99fc0867c1d236155c624b4d88636f4c1e6bbe'

  def install
    bin.install Dir['*']
  end

  def caveats; <<-EOS.undent
    # append to ~/.profile on Ubuntu, or to ~/.zshrc on Zsh
    $ echo 'eval "$(uru_rt admin install)"' >> ~/.bash_profile

    # register a pre-existing "system" ruby already placed on PATH from bash/Zsh
    # startup configuration files
    $ uru_rt admin add system

    # restart shell
    $ exec $SHELL -l
    EOS
  end

  test do
    system "#{bin}/uru_rt"
  end
end
