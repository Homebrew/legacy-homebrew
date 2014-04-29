require 'formula'

class CocaineCore < Formula
  homepage 'https://github.com/cocaine/cocaine-core'
  url 'https://github.com/cocaine/cocaine-core', :using => :git, :tag => '0.11.2.0'
  sha1 'd045c8586a435e1bb29a3405f43cddc0e651a119'
  version '0.11.2.0'

  depends_on 'cmake' => :build
  depends_on 'boost' => 'c++11'
  depends_on 'libarchive'
  depends_on 'libev'
  depends_on 'libtool' => :build
  depends_on 'msgpack'

  def install
    system 'cmake', '.', *std_cmake_args
    system 'make', 'install'
  end

  test do
    system "#{bin}/cocaine-runtime --version"
  end
end
