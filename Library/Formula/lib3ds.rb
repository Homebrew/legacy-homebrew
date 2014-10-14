require 'formula'

class Lib3ds < Formula
  homepage 'http://code.google.com/p/lib3ds/'
  url 'https://lib3ds.googlecode.com/files/lib3ds-1.3.0.zip'
  sha1 '544262eac73c1e4a1d77f0f1cbd90b990a996db8'

  bottle do
    cellar :any
    sha1 "53ae4cb6db633897d434cdfe95b07ca516dd1717" => :mavericks
    sha1 "db5fdf01d5a6b33ca98bd5a6be84ca9861e4685e" => :mountain_lion
    sha1 "888a38373b52991adeaa1c91d46fe89cb7e820cb" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
