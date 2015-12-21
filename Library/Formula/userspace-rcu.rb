class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://lttng.org/urcu"
  url "https://www.lttng.org/files/urcu/userspace-rcu-0.9.1.tar.bz2"
  sha256 "f8d278e9d95bec97c9ba954fc4c3fb584936bc0010713a8fe358b916bafd8715"

  bottle do
    cellar :any
    sha256 "f0c0badb4e39284c68fee23e2abed3055150b696d374dcc3b46f02c607fccbdc" => :yosemite
    sha256 "37c33ee463ea71b2deca8ab72d02d9191846cf2ddd639cf1eb51a8039db2eeb5" => :mavericks
    sha256 "e9ba30f7d6e8eae7bb7fed85d65dbaf7c3d970eb764d03b5561d6d91e3d01871" => :mountain_lion
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]
    # workaround broken upstream detection of build platform
    # marked as wontfix: http://bugs.lttng.org/issues/578#note-1
    if MacOS.prefer_64_bit?
      args << "--build=#{Hardware::CPU.arch_64_bit}"
    end

    # workaround broken syscall.h detection
    inreplace "urcu/syscall-compat.h", "defined(__sun__)", "defined(__APPLE__)"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    cp_r "#{doc}/examples", testpath
    system "make", "-C", "examples"
  end
end
