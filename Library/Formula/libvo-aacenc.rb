require 'formula'

class LibvoAacenc < Formula
  homepage 'http://opencore-amr.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/opencore-amr/vo-aacenc/vo-aacenc-0.1.2.tar.gz'
  sha1 'ac56325c05eba4c4f8fe2c5443121753f4d70255'

  bottle do
    cellar :any
    sha1 "13e263c11a0e1431c5daf789e48477a2b7f7a9e7" => :mavericks
    sha1 "e07bee5297b94675f3a85f541edd8585e57507cd" => :mountain_lion
    sha1 "0943e4022c9f9f34a43a1a2f59cd785916a64c00" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
