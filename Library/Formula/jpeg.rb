require 'formula'

class Jpeg < Formula
  homepage 'http://www.ijg.org'
  url 'http://www.ijg.org/files/jpegsrc.v8d.tar.gz'
  sha1 'f080b2fffc7581f7d19b968092ba9ebc234556ff'

  bottle do
    cellar :any
    sha1 '1f61eefc3d5dec2028c80afec203219b29a9d28d' => :mavericks
    sha1 '403549b7b3b3e34a58e24b8e08bb3aa7e6dc3d6e' => :mountain_lion
    sha1 '29648a413e64c64758619fc6c5bff737b4d2e1de' => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
