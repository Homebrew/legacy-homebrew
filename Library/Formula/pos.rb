require 'formula'

class Pos < Formula
  url 'http://www.finkproject.org/bindist/dists/fink-0.9.0/main/source/utils/pos-1.2.tgz'
  md5 'c667fb4ca38c96494f888ade9fb4e40a'
  homepage "http://sage.ucsc.edu/~wgscott/xtal/wiki/index.php/Unix_and_OS_X:_The_Absolute_Essentials"

  def install
    bin.install %w[bin/fdc bin/posd]
    share.install %w[Finder_Toolbar_Applications.dmg.gz iTerm.webloc]
  end

  def caveats
      <<-EOS.undent
      cdf (change terminal window to current finder window)
      needs to be installed as an alias in your shell init.
      For example, add the following to your .bash_profile:
        if [ -f `brew --prefix`/bin/posd ]; then
          alias cdf='cd "`posd`"'
        fi
      EOS
  end
end
