require 'formula'

class Pixman < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/releases/pixman-0.32.4.tar.gz'
  sha256 '80c7ed420e8a3ae749800241e6347c3d55681296cab71384be7969cd9e657e84'

  bottle do
    cellar :any
    sha1 "d4a8df1a31807a916a7d9b457a3835190494f9b1" => :mavericks
    sha1 "d0b49f5a7a456a8491ec0d4a59113ec89b99bc4e" => :mountain_lion
    sha1 "fd40b113d86707cab39c3e078c8eddf7db968560" => :lion
  end

  depends_on 'pkg-config' => :build

  keg_only :provided_pre_mountain_lion

  option :universal

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
      Building with llvm-gcc causes PDF rendering issues in Cairo.
      https://trac.macports.org/ticket/30370
      See Homebrew issues #6631, #7140, #7463, #7523.
      EOS
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gtk"
    system "make", "install"
  end
end
