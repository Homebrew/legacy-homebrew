require 'formula'

class LadspaSdk < Formula
  url 'http://www.ladspa.org/download/ladspa_sdk_1.13.tgz'
  homepage 'http://ladspa.org'
  md5 '671be3e1021d0722cadc7fb27054628e'

  def patches
    # fix endian.h for osx
    # remove deprecated library initializers
    { :p1 => ["http://gist.github.com/raw/462817/abfdc6a9b1b91cff71ec92cef88ac2aa37b38ff2/fix-endian.h",
              "http://gist.github.com/raw/462824/d1ecb236c142a331765ffef9bef7b562849a22c3/remove%20deprecated%20library%20initializers"] }
  end

  def install
    system "cd src; make -f makefile"

    bin.install Dir['bin/*']
    include.install ['src/ladspa.h']
    (share + 'ladspa').install Dir['plugins/*']
  end
end
