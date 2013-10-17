require 'formula'

class Cask < Formula
  homepage 'http://cask.github.io/'
  url 'https://github.com/cask/cask/archive/v0.4.6.zip'
  sha1 '01435f38593f74d5d9a68844121f2374bf08de30'
  head 'https://github.com/cask/cask.git'
  
  depends_on 'emacs'

  option 'without-completions', 'Disable zsh completions'
  
  def install

    unless build.without? 'completions'
      zsh_completion.install 'etc/cask_completion.zsh'
    end

    bin.install 'bin/cask'
    prefix.install 'Cask'
    prefix.install Dir['*.el']
    prefix.install 'server'
    prefix.install 'templates'

  end

end
