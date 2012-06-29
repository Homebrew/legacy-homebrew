require 'formula'

class Lbdb < Formula
  url 'https://github.com/tgray/lbdb/tarball/v0.38.1'
  # homepage 'https://github.com/tgray/lbdb/'
  homepage 'http://www.spinnaker.de/lbdb/'
  head 'git://github.com/tgray/lbdb.git'
  
  unless ARGV.build_head?
    md5 '6f8633677f0583e49f9f8a2afbf6bd32'
  end

  def caveats; <<-EOS.undent
    lbdb from <http://www.spinnaker.de/lbdb/> doesn't build on OS X because the
    XCode project file is not compatible with XCode 4 or OS X 10.7.  This
    version of lbdb has been modified to fix this.  A query was sent to the
    upstream maintainer to see if he was interested in the patch, but so far,
    there has been no response.

    The homepage of this version is <https://github.com/tgray/lbdb/>
    EOS
  end
  
  def install
    args = [ "--disable-dependency-tracking", "--prefix=#{prefix}" ]
    system "./configure", *args
    system "make install"
  end
end
