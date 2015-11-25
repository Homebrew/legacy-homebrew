class Libmpeg2 < Formula
  desc "Library to decode mpeg-2 and mpeg-1 video streams"
  homepage "http://libmpeg2.sourceforge.net/"
  url "http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.1.tar.gz"
  sha256 "dee22e893cb5fc2b2b6ebd60b88478ab8556cb3b93f9a0d7ce8f3b61851871d4"

  bottle do
    cellar :any
    revision 1
    sha256 "841e93dd99b97b96b475aedff29b58f5be5c4156869b1c0212e5d7ed8dd7f481" => :el_capitan
    sha256 "3d07c45554ff34036b9eae5a31dc5417c15109ba134d414035b1bf6f9dda7c79" => :yosemite
    sha256 "f6a868beb10fbf84d3eb1af556478ecbfb238d28608a53b99e607c02910e5e49" => :mavericks
    sha256 "eb8eb837e902d0fbdd6c89c72a2d7f534e0edf9a0895807f7f05a2505b900e5f" => :mountain_lion
  end

  depends_on "sdl"

  def install
    # Otherwise compilation fails in clang with `duplicate symbol ___sputc`
    ENV.append_to_cflags "-std=gnu89"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
