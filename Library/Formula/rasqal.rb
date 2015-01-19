require 'formula'

class Rasqal < Formula
  homepage 'http://librdf.org/rasqal/'
  url 'http://download.librdf.org/source/rasqal-0.9.33.tar.gz'
  sha1 '281c2e0a352c53ef1656bfe778c380226d61726f'

  bottle do
    cellar :any
    sha1 "ae7032203542c925adf5d0a34534800dcef977da" => :yosemite
    sha1 "6eaf0dff02885a7bb47c95e81c946ae2c20ce4d7" => :mavericks
    sha1 "fe5e343d56bb7c255f7ac18729ec54928d3be73a" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'raptor'

  def install
    system './configure', "--prefix=#{prefix}",
                          "--with-html-dir=#{share}/doc",
                          '--disable-dependency-tracking'
    system "make install"
  end
end
