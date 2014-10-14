require 'formula'

class Libntlm < Formula
  homepage 'http://www.nongnu.org/libntlm/'
  url 'http://www.nongnu.org/libntlm/releases/libntlm-1.4.tar.gz'
  sha1 'b15c9ccbd3829154647b3f9d6594b1ffe4491b6f'

  bottle do
    cellar :any
    sha1 "8804ed8011884a460f8f6b0f6097623c31a68a9b" => :mavericks
    sha1 "8412db1ae3c69bdb3d96b144ef69af450637f5a5" => :mountain_lion
    sha1 "95872dc71ec6220794923681f4a364ba9f538bd7" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
