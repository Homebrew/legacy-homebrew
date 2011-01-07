require 'formula'

class Colormake <Formula
  url 'http://bre.klaki.net/programs/colormake/colormake-0.2.tar.gz'
  homepage 'http://bre.klaki.net/programs/colormake/'
  md5 '1029dae70e7a23cff0f6a11f3ceffbe1'

  def install
    where_to = (share+'colormake')
    where_to.install 'colormake.pl'

    # The following two scripts are not the ones shipped with colormake,
    # but heavily based on the ones used by Debian.
    (bin+'colormake').write <<-EOS
#!/bin/sh
/usr/bin/make \"$@\" 2>&1 | #{where_to}/colormake.pl
exit ${PIPESTATUS[0]}
EOS

    (bin+'clmake').write <<-EOS
#!/bin/sh
SIZE=`/bin/stty size`
[ -z "${CLMAKE_OPTS}" ] && CLMAKE_OPTS='-r -pError'
/usr/bin/make \"$@\" 2>&1 | #{where_to}/colormake.pl $SIZE | /usr/bin/less ${CLMAKE_OPTS}
exit ${PIPESTATUS[0]}
EOS
  end
end
