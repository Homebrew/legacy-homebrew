require 'formula'

class Jpeg < Formula
  homepage 'http://www.ijg.org'
  url 'http://www.ijg.org/files/jpegsrc.v8d.tar.gz'
  sha1 'f080b2fffc7581f7d19b968092ba9ebc234556ff'

  bottle do
    cellar :any
    revision 2
    sha1 "a0d4d16fcbee7ad6ef49f16bb55650291b877885" => :yosemite
    sha1 'f668b1e9cb382e194c632c1d5865b7bea096c3ac' => :mavericks
    sha1 '4dd056f2bf243eef145a613ed1a51e65e4b5d0a4' => :mountain_lion
    sha1 '396612e00ac31ca730d913ebdfd1b99881304702' => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
