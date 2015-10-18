class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz"
  mirror "https://fossies.org/linux/misc/tree-1.7.0.tgz"
  sha256 "6957c20e82561ac4231638996e74f4cfa4e6faabc5a2f511f0b4e3940e8f7b12"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "2721bafcbe1db12e444f5025bdae81aa3c7cff6572aa7423e401baeb10a43157" => :el_capitan
    sha256 "c1ad4f32c4922cbd1e37aa55b8fa6e0cc8a04c96a24f0d9e7957b50b311d854d" => :yosemite
    sha256 "0bcb8a1de3ed51295917d6dd997ea492048f90a5ee1084676171a39dbd489654" => :mavericks
    sha256 "c3bd091797c487bb1ac5586d0e524da341c6043b0298269a9ded271646274fa3" => :mountain_lion
  end

  def install
    ENV.append "CFLAGS", "-fomit-frame-pointer"
    objs = "tree.o unix.o html.o xml.o hash.o color.o strverscmp.o json.o"

    system "make", "prefix=#{prefix}",
                   "MANDIR=#{man1}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "OBJS=#{objs}",
                   "install"
  end

  test do
    system "#{bin}/tree", prefix
  end
end
