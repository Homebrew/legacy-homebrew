require 'formula'

class Tree < Formula
  homepage 'http://mama.indstate.edu/users/ice/tree/'
  url 'http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz'
  sha1 '35bd212606e6c5d60f4d5062f4a59bb7b7b25949'

  bottle do
    cellar :any
    sha1 "de86a6212934b258c2f64f6ae3460e8b729fc357" => :mavericks
    sha1 "59991b24b9b236236bd2aa3eaa6050be48ee106f" => :mountain_lion
    sha1 "3e30b09d1e08c017bb7f7e07150f9c9a7b009d2a" => :lion
  end

  def install
    ENV.append 'CFLAGS', '-fomit-frame-pointer', '-no-cpp-precomp'
    inreplace 'Makefile' do |s|
      s.change_make_var! "OBJS", "\\1 strverscmp.o"
    end

    system "make", "prefix=#{prefix}",
                   "install"
  end

  test do
    system "#{bin}/tree", prefix
  end
end
