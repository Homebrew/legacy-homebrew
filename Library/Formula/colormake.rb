require 'formula'

class Colormake < Formula
  homepage 'http://bre.klaki.net/programs/colormake/'
  url 'http://bre.klaki.net/programs/colormake/colormake-0.9.tar.gz'
  sha1 '6c5ab4be23d60ec79ed4c43cbeb142bfd4a4e626'

  def install
    libexec.install 'colormake.pl'

    # The following two scripts are not the ones shipped with colormake,
    # but heavily based on the ones used by Debian.
    (bin+'colormake').write <<-EOS.undent
      #!/bin/sh
      /usr/bin/make \"$@\" 2>&1 | #{libexec}/colormake.pl
      exit ${PIPESTATUS[0]}
    EOS

    (bin+'clmake').write <<-EOS.undent
      #!/bin/sh
      SIZE=`/bin/stty size`
      [ -z "${CLMAKE_OPTS}" ] && CLMAKE_OPTS='-r -pError'
      /usr/bin/make \"$@\" 2>&1 | #{libexec}/colormake.pl $SIZE | /usr/bin/less ${CLMAKE_OPTS}
      exit ${PIPESTATUS[0]}
    EOS
  end
end
