require 'formula'

class OpenXenManager < Formula
  homepage 'http://sourceforge.net/projects/openxenmanager/'
  url 'http://downloads.sourceforge.net/project/openxenmanager/openxenmanager_rev48.tar.gz'
  sha1 'd406e923363adcc4b5876b0a56207adf2c4f8718'
  version 'rev48'

  head 'svn://svn.code.sf.net/p/openxenmanager/code/trunk'

  depends_on :python
  depends_on 'pygtk'
  depends_on 'rrdtool' => :recommended
  depends_on 'tiger-vnc' => :recommended

  def install
    share.install Dir['*']
    #
    # openxenmanager provides no actual binary and
    # is no proper python module, either. We provide a wrapper
    # akin to what debian does:
    #   http://anonscm.debian.org/gitweb/?p=collab-maint/openxenmanager.git;a=blob;f=debian/openxenmanager.sh
    #
    (bin/'openxenmanager').write DATA.read.gsub('PYTHONXY', python.xy).gsub('SHAREPATH', share.to_s)
    unless build.without? 'tiger-vnc'
      # openxenmanager expects vncviewer _local_ to its installation path
      (share/'vncviewer').make_symlink(HOMEBREW_PREFIX+'opt/tiger-vnc/bin/vncviewer')
    end
  end

end
__END__
#!/bin/sh
#
# OpenXenManager wrapper
#
DIR=`pwd`
cd SHAREPATH
PYTHONPATH=`brew --prefix`/lib/PYTHONXY/site-packages:$PYTHONPATH python window.py
cd "$DIR"
