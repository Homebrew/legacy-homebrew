require 'formula'
require 'download_strategy'

class VmallocDownloadStrategy <CurlDownloadStrategy
  def _fetch
    # downloading from AT&T requires using the following credentials
    credentials = 'I accept www.opensource.org/licenses/cpl:.'
    curl @url, '--output', @tarball_path, '--user', credentials
  end
end

class Vmalloc < Formula
  url 'http://www2.research.att.com/~gsf/download/tgz/vmalloc.2005-02-01.tgz',
      :using => VmallocDownloadStrategy
  homepage 'http://www2.research.att.com/sw/download/'
  md5 '564db0825820ecd18308de2933075980'
  version '2005-02-01'

  def install
    # Vmalloc makefile does not work in parallel mode
    ENV.deparallelize
    # override Vmalloc makefile flags
    inreplace Dir['src/**/Makefile'] do |s|
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CXFLAGS", ENV.cflags
      s.change_make_var! "CCMODE", ""
    end
    # make all Vmalloc stuff
    system "/bin/sh ./Runmake"
    # install manually
    # put all includes into a directory of their own
    (include + "vmalloc").install Dir['include/*.h']
    lib.install Dir['lib/*.a']
    man.install 'man/man3'
  end

  def caveats; <<-EOS.undent
    We agreed to the OSI Common Public License Version 1.0 for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end
