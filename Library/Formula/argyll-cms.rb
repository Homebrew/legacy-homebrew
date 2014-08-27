require 'formula'

class ArgyllCms < Formula
  homepage 'http://www.argyllcms.com/'
  url 'http://www.argyllcms.com/Argyll_V1.6.3_src.zip'
  sha1 '0c4d48a6cf6800a8d445bf6cd3c248a40799cf14'
  version '1.6.3'

  depends_on 'jam' => :build
  depends_on 'jpeg'
  depends_on 'libtiff'

  def install
    system "sh", "makeall.sh"
    system "./makeinstall.sh"
    rm "bin/License.txt"
    prefix.install "bin", "ref", "doc"
  end
end
