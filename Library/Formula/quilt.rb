require 'formula'

class Quilt < Formula
  homepage 'http://savannah.nongnu.org/projects/quilt'
  url 'http://download.savannah.gnu.org/releases/quilt/quilt-0.63.tar.gz'
  sha1 '19f2ba0384521eb3d8269b8a1097b16b07339be5'

  bottle do
    sha1 "04771a84ee741ad82390373e126db9969cb1abae" => :mavericks
    sha1 "2516d559ab9d366d510972c48e7c9250b04b1edc" => :mountain_lion
    sha1 "1e30a1d5d3df8af87ae2b34e1423aec0761992a9" => :lion
  end

  depends_on 'gnu-sed'
  depends_on 'coreutils'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-sed=#{HOMEBREW_PREFIX}/bin/gsed",
                          "--without-getopt"
    system "make"
    system "make install"
  end
end
