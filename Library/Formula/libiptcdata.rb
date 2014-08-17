require 'formula'

class Libiptcdata < Formula
  homepage 'http://libiptcdata.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/libiptcdata/libiptcdata/1.0.4/libiptcdata-1.0.4.tar.gz'
  sha1 '2e967be3aee9ae5393f208a3df2b52e08dcd98c8'

  bottle do
    sha1 "d75dcfef6d607236366189345799326acaffc3e2" => :mavericks
    sha1 "3f132d3a1e5348c1e5f41e53eb819960c92079e5" => :mountain_lion
    sha1 "7e1c231bfa5cd74f58ca568073244f20791937b8" => :lion
  end

  depends_on 'gettext'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
