require "formula"

class UserspaceRcu < Formula
  homepage "http://lttng.org/urcu"
  url "http://lttng.org/files/urcu/userspace-rcu-0.8.4.tar.bz2"
  sha1 "4b3bf1b76e6ea50d9a56d9e5e00df2cc7c4d610f"

  bottle do
    cellar :any
    sha1 "16c1a7476c1f43cfdee4b3410dc2a91b7c84ba5c" => :mavericks
    sha1 "e914e384c50f1fcde334f4ea059c62305b5e60ca" => :mountain_lion
    sha1 "be83fc32071b02e3881a67119e3944166d8f81ad" => :lion
  end

  def install
    args = ["--disable-dependency-tracking", "--disable-silent-rules",
            "--disable-rpath", "--prefix=#{prefix}"]
    # workaround broken upstream detection of build platform
    if MacOS.prefer_64_bit?
      args << "--build=#{Hardware::CPU.arch_64_bit}"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "cp", "-a", "#{doc}/examples", "."
    system "make", "-C", "examples"
  end
end
