require 'formula'

class Tree < Formula
  homepage 'http://mama.indstate.edu/users/ice/tree/'
  url 'http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz'
  sha1 '35bd212606e6c5d60f4d5062f4a59bb7b7b25949'

  bottle do
    cellar :any
    sha1 "d2e9699fce73145917f2b15f7f932765a47e1be6" => :mavericks
    sha1 "7bdbb4ca0cc98d12c7fae1926c654786600beb0d" => :mountain_lion
    sha1 "c92ed70a7a7d15f7ce5ee75a6851b59de11cf431" => :lion
  end

  def install
    ENV.append 'CFLAGS', '-fomit-frame-pointer', '-no-cpp-precomp'
    inreplace 'Makefile' do |s|
      s.change_make_var! "OBJS", "\\1 strverscmp.o"
      s.change_make_var! "MANDIR", man1
    end

    system "make", "prefix=#{prefix}",
                   "install"
  end

  test do
    system "#{bin}/tree", prefix
  end
end
