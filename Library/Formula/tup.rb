require 'formula'

class Tup < Formula
  homepage 'http://gittup.org/tup/'
  url 'https://github.com/gittup/tup/archive/v0.7.tar.gz'
  sha1 '1ee3765d90a5262d56222846c698b0d555705099'
  head 'https://github.com/gittup/tup.git'

  depends_on 'pkg-config' => :build
  depends_on 'osxfuse'

  def patches
    # replace fuse with its successor osxfuse
    "https://gist.github.com/nikolay/7242850/raw/d54726a37cdde738b995203ad6f433d88f2962d6/tup.patch"
  end

  def install
    ENV['TUP_LABEL'] = version
    system "./build.sh"
    bin.install 'build/tup'
    man1.install 'tup.1'
  end

  def test
    system "#{bin}/tup", "-v"
  end

  def caveats; <<-EOS.undent
    Make sure to follow the directions given by `brew info osxfuse`
    before using 'tup' build tool.
    EOS
  end
end
