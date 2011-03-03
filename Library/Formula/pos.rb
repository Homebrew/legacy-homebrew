require 'formula'

class Pos <Formula
  url 'http://www.finkproject.org/bindist/dists/fink-0.9.0/main/source/utils/pos-1.2.tgz'
  md5 'c667fb4ca38c96494f888ade9fb4e40a'
  homepage "http://sage.ucsc.edu/~wgscott/xtal/wiki/index.php/Unix_and_OS_X:_The_Absolute_Essentials"

  def cdf_script; <<-END
#!/bin/bash
cd "$(posd)"
END
  end

  def install
    bin.install %w[bin/fdc bin/posd]
    (bin+'cdf').write cdf_script
    share.install %w[Finder_Toolbar_Applications.dmg.gz iTerm.webloc]
  end
end
