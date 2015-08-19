class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz"
  mirror "https://fossies.org/linux/misc/tree-1.7.0.tgz"
  sha256 "6957c20e82561ac4231638996e74f4cfa4e6faabc5a2f511f0b4e3940e8f7b12"

  bottle do
    cellar :any
    sha1 "d2e9699fce73145917f2b15f7f932765a47e1be6" => :mavericks
    sha1 "7bdbb4ca0cc98d12c7fae1926c654786600beb0d" => :mountain_lion
    sha1 "c92ed70a7a7d15f7ce5ee75a6851b59de11cf431" => :lion
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
