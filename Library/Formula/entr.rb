require 'formula'

class Entr < Formula
  homepage 'http://entrproject.org/'
  url 'http://entrproject.org/code/entr-3.0.tar.gz'
  sha1 'e7c5f589b2bce839464052b116a051b4d8f43f23'

  bottle do
    cellar :any
    sha1 "da32289bea210e36f6dffe7ef419d5ea8654afb2" => :yosemite
    sha1 "b6a84ff6bddd4d59b3abf4a706b1a70d19e302f4" => :mavericks
    sha1 "10422a889ccdc6bcb411d505407c43f6412e8443" => :mountain_lion
  end

  def install
    ENV['PREFIX'] = prefix
    ENV['MANPREFIX'] = man
    system "./configure"
    system "make"
    system "make install"
  end
end
