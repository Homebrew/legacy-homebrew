require 'formula'

class Ilmbase < Formula
  homepage 'http://www.openexr.com/'
  url 'http://download.savannah.gnu.org/releases/openexr/ilmbase-2.1.0.tar.gz'
  mirror 'http://download-mirror.savannah.gnu.org/releases/openexr/ilmbase-2.1.0.tar.gz'
  sha1 '306d76e7a2ac619c2f641f54b59dd95576525192'

  bottle do
    cellar :any
    sha1 "67cf40c3005626fb67d16d65dd06dade0ebcbf6f" => :mavericks
    sha1 "1a307dc1f9aa13166527fe9cf86002462eff76fb" => :mountain_lion
    sha1 "20913f21a73681bc3761037be29ba44ea5feed29" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

