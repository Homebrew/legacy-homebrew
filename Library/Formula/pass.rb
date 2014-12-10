require 'formula'

class GpgRequirement < Requirement
  fatal true
  default_formula 'gnupg2'

  satisfy do
    %w(gpg gpg2).any? { |gpg| which gpg }
  end

  def message; <<-EOS.undent
    pass requires GPG to be installed. Please install GPG in one of three ways:
    - Install the gnupg2 package through Homebrew
    - Install the gpgtools package through Homebrew Cask
    - Download and install gpgtools from https://gpgtools.org/
    EOS
  end
end

class Pass < Formula
  homepage 'http://www.passwordstore.org/'
  url 'http://git.zx2c4.com/password-store/snapshot/password-store-1.6.3.tar.xz'
  sha256 'd419d40aa165c1f893e994dd706733374a9db8cf5314124702a061e70e0340f7'

  bottle do
    cellar :any
    sha1 "c7c430873e8272725a8f0cab1b9c50371d3bf9e4" => :mavericks
    sha1 "1eb5751288c8d4eb3dd5d3a75451e913d38ce0c1" => :mountain_lion
    sha1 "289089c797ae46fe7ef93e4755f3847ecd38098c" => :lion
  end

  head 'http://git.zx2c4.com/password-store', :using => :git

  depends_on 'pwgen'
  depends_on 'tree'
  depends_on 'gnu-getopt'
  depends_on GpgRequirement

  def install
    system "make DESTDIR=#{prefix} PREFIX=/ install"
    share.install "contrib"
    zsh_completion.install "src/completion/pass.zsh-completion" => "_pass"
    bash_completion.install "src/completion/pass.bash-completion" => "password-store"
  end

  test do
    system "#{bin}/pass", "--version"
  end
end
