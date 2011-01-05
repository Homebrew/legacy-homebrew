require 'formula'

# This is a binary package because, like GHC, MLton requires a recent
# version of itself to build, and bootstrapping is basically pointless.
# The build here is statically linked to gmp, since the dynamically-linked
# binary requires gmp to be in /opt/local/lib; the generated binaries are
# still dependent on a dynamically-linked gmp, however, which is why it
# is listed as a dependency.
class Mlton < Formula
  homepage 'http://mlton.org/'
  url 'http://mlton.org/pages/Download/attachments/mlton-20100608-1.amd64-darwin.gmp-static.tgz'
  version '20100608'
  md5 'd32430f2b66f05ac0ef6ff087ea109ca'

  depends_on 'gmp'

  def replace_all foo, bar
    # Find all text files containing foo and replace it with bar
    files = `/usr/bin/grep -lsIR #{foo} .`.split
    inreplace files, foo, bar
  end

  def install
    # We end up in usr/ for some reason
    cd 'local'

    # Do we need to replace all the different dirs (e.g. lib) separately here?
    replace_all '/usr/local', prefix

    prefix.install ['bin', 'lib']
    man.install Dir['man/*']
    share.install Dir['share/*']
  end
end
