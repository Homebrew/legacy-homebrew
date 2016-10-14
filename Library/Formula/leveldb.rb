require 'formula'

class Leveldb < Formula
  head "https://code.google.com/p/leveldb/", :using => :git
  homepage 'http://leveldb.googlecode.com'

  depends_on 'snappy'

  def install
    system "make"
    lib.install Dir["libleveldb*"]
    include.install Dir["include/*"]
  end

  def patches
    # allows generation of shared lib (on issue tracker)
    "https://raw.github.com/gist/1360052/31d0c4062c23ab2e241535b751cd73ab567bf6b8/generating-shared-lib.patch"
  end
end
