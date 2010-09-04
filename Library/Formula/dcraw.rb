require 'formula'

class Dcraw <Formula
  # Note that the file is versioned, but not in source control,
  # so updates are random and break the MD5. If you try to install
  # and get an MD5 mismatch, check for a newer version number on
  # http://www.cybercom.net/~dcoffin/dcraw/RCS/dcraw.c,v
  # and update the version and MD5 in a patch. Thanks.
  homepage 'http://www.cybercom.net/~dcoffin/dcraw/'
  url 'http://www.cybercom.net/~dcoffin/dcraw/dcraw.c'
  version '1.436'
  md5 'd680b17ce75ab1c791fe92b467f1005d'

  depends_on 'jpeg'
  depends_on 'little-cms'

  def install
    system "#{ENV.cc} -o dcraw #{ENV.cflags} dcraw.c -lm -ljpeg -llcms"
    bin.install 'dcraw'
  end
end
