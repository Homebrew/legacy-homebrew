require 'formula'

class Uru < Formula
  homepage 'https://bitbucket.org/jonforums/uru'
  url 'https://bitbucket.org/jonforums/uru/get/v0.7.4.tar.gz'
  version '0.7.4'
  sha1 '24b91db240e324d2738ad1f19079aed41b9cfdbf'
  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system 'go', 'get', '-ldflags', '-s', 'bitbucket.org/jonforums/uru'
    bin.install 'bin/uru' => 'uru_rt'
  end

  def caveats; <<-EOS.undent
    # Append to ~/.profile on Ubuntu, or to ~/.zshrc on Zsh
    $ echo 'eval "$(uru_rt admin install)"' >> ~/.bash_profile

    # Register a pre-existing "system" ruby already placed on PATH from bash/Zsh
    # startup configuration files
    $ uru_rt admin add system

    # Restart shell
    $ exec $SHELL -l
    EOS
  end

  test do
    system "#{bin}/uru_rt"
  end
end
