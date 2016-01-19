class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://lttng.org/urcu"
  url "https://www.lttng.org/files/urcu/userspace-rcu-0.9.1.tar.bz2"
  sha256 "f8d278e9d95bec97c9ba954fc4c3fb584936bc0010713a8fe358b916bafd8715"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0b393a777b07767cef195b897777e9b65d9186e4307a2ce5a20989082a97976" => :el_capitan
    sha256 "2842341210131cff185ace17b10599eaa002fc60407267322749191ae5fa1fdc" => :yosemite
    sha256 "03e24c928b31060eecb8de113be45f0ae8d70ee20073d481a2244d10ae4d1825" => :mavericks
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
