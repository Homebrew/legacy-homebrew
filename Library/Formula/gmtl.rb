require 'formula'

class Gmtl < Formula
  url 'http://downloads.sourceforge.net/project/ggt/Generic%20Math%20Template%20Library/0.6.1/gmtl-0.6.1.tar.gz'
  homepage 'http://ggt.sourceforge.net/'
  md5 '1391af2c5ea050dda7735855ea5bb4c1'
  head 'https://ggt.svn.sourceforge.net/svnroot/ggt/trunk/'

  depends_on 'scons' => :build

  # Build assumes that Python is a framework, which isn't always true. See:
  # https://sourceforge.net/tracker/?func=detail&aid=3172856&group_id=43735&atid=437247
  # The SConstruct from gmtl's HEAD doesn't need to be patched
  def patches
    "https://gist.github.com/raw/811405/fix-gmtl-build.diff" unless ARGV.build_head?
  end

  def install
    system "scons", "install", "prefix=#{prefix}"
  end
end
