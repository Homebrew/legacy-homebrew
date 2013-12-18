require 'formula'

class Pbrt < Formula
  homepage 'http://pbrt.org/'
  url 'https://github.com/mmp/pbrt-v2/archive/2.0.342.tar.gz'
  sha1 'c18e4cb5acdd3120573c26be702e452e77273a79'

  depends_on "openexr"

  def install
    cd "src" do
      system "make"
      prefix.install "bin"
    end
  end
end
