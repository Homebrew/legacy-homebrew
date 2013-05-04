require 'formula'

class Dmd < Formula
  homepage 'http://www.digitalmars.com/d/'
  url 'http://downloads.dlang.org.s3-website-us-east-1.amazonaws.com/releases/2013/dmd.2.062.zip'
  sha1 '02caec18aeb55ff2d2251925e867340f58617c80'

  def install
    # clean it up a little first
    rm Dir['src/*.mak']
    mv 'license.txt', 'COPYING'
    mv 'README.TXT', 'README'

    cd 'osx/bin' do
      mv 'dmdx.conf', 'dmd.conf'
      inreplace 'dmd.conf', '~/dmd2', prefix
    end

    rmtree 'src/dmd'
    prefix.install 'osx/bin', 'osx/lib', 'src'

    man.install 'man/man1'
    man5.install man1/'dmd.conf.5'

    (share+'d/examples').install Dir['samples/d/*.d']
  end
end
