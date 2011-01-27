require 'formula'

class DcrawManual <Formula
  url 'http://www.cybercom.net/~dcoffin/dcraw/dcraw.1'
  md5 '6ba2a797c4ad698589f83171d6b36396'
  version '1.50'
end

class Dcraw <Formula
  homepage 'http://www.cybercom.net/~dcoffin/dcraw/'
  url 'http://www.cybercom.net/~dcoffin/dcraw/dcraw.c'
  version '1.438'
  md5 '108f0c14a5be4d092c7ffa8460044fb3'

  depends_on 'jpeg'
  depends_on 'little-cms'

  def install
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    system "#{ENV.cc} -o dcraw #{ENV.cflags} dcraw.c -lm -ljpeg -llcms"
    bin.install 'dcraw'
    DcrawManual.new.brew { man1.install Dir['*'] }
  end

  def caveats; <<-EOS.undent
    Note that the files are versioned, but not in source control,
    so updates are random and break the MD5. If you try to install
    and get an MD5 mismatch, check for a newer version number on
    the following files and update the version and MD5 in a patch. Thanks!
    http://www.cybercom.net/~dcoffin/dcraw/RCS/dcraw.c,v
    http://www.cybercom.net/~dcoffin/dcraw/RCS/dcraw.1,v
    EOS
  end
end
