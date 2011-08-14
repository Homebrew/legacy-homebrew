require 'formula'

class Rbenv < Formula
  homepage 'https://github.com/sstephenson/rbenv'
  url 'https://github.com/sstephenson/rbenv.git', :tag => 'v0.1.0', :using => GitDownloadStrategy
  version '0.1.0'
  head 'https://github.com/sstephenson/rbenv.git', :using => GitDownloadStrategy

  def skip_clean?(path)
    true
  end

  def install
    prefix.install Dir['*']
    versions_dir = "#{prefix}/versions"
    system "mkdir #{versions_dir}"
  end

  def caveats; <<-EOS.undent
    To finish installing rbenv, add the following lines to your .bash_profile or .zshrc
      eval "$(rbenv init -)"
      export RBENV_VERSION=#{prefix}/versions

    To install a Ruby version, download the source and configure using a command such as:
      ./configure --prefix=$RBENV_VERSION/1.9.2-p290
      make && make install
    EOS
  end
end

