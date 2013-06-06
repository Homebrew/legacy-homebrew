require 'formula'

class Pos < Formula
  homepage "http://sage.ucsc.edu/~wgscott/xtal/wiki/index.php/Unix_and_OS_X:_The_Absolute_Essentials"
  url 'http://www.finkproject.org/bindist/dists/fink-0.9.0/main/source/utils/pos-1.2.tgz'
  sha1 '320dc42b80508338f2f5f4e330d0c39462e3bba8'

  def install
    bin.install %w[bin/fdc bin/posd]
    share.install %w[Finder_Toolbar_Applications.dmg.gz iTerm.webloc]
  end

  def caveats; <<-EOS.undent
    cdf (change terminal window to current finder window)
    needs to be installed as an alias in your shell init.
    For example, add the following to your .bash_profile:
      if [ -f `brew --prefix`/bin/posd ]; then
        alias cdf='cd "`posd`"'
      fi
    EOS
  end
end
