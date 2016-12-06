require 'formula'

class Bindfs < Formula
  url 'http://bindfs.googlecode.com/files/bindfs-1.9.tar.gz'
  homepage 'http://code.google.com/p/bindfs/'

  md5 '610778ad89bc5b0ff0be7b44bb2b6f0c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
    This depends on the MacFUSE installation from http://code.google.com/p/macfuse/
    MacFUSE must be installed prior to installing this formula.
    EOS
  end

end
