require 'formula'

class Colormake < Formula
  homepage 'http://bre.klaki.net/programs/colormake/'
  head 'https://github.com/pagekite/Colormake.git'

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
