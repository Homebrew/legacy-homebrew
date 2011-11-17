require 'formula'

class Squashfs < Formula
  homepage 'http://squashfs.sourceforge.net/'
  url 'http://sourceforge.net/projects/squashfs/files/squashfs/squashfs4.0/squashfs4.0.tar.gz/download'
  md5 'a3c23391da4ebab0ac4a75021ddabf96'

  def install
    system "cd squashfs-tools; sed -i.orig 's/\|FNM_EXTMATCH//' $(grep -l FNM_EXTMATCH *)"
    system "cd squashfs-tools; sed -i.orig $'/#include \"unsquashfs.h\"/{i\\\n#include <sys/sysctl.h>\n}' unsquashfs.c"
    system "cd squashfs-tools; make"

    bin.install ["squashfs-tools/mksquashfs", "squashfs-tools/unsquashfs"]

    doc.install %w{ACKNOWLEDGEMENTS CHANGES COPYING INSTALL OLD-READMEs PERFORMANCE.README README README-4.0}
  end
end
