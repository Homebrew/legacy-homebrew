class UserspaceRcu < Formula
  homepage "https://lttng.org/urcu"
  url "https://www.lttng.org/files/urcu/userspace-rcu-0.8.7.tar.bz2"
  sha256 "b523f22c4726ca6bb77a77d258e76d8c33c89724433bd65313024b98e55c4295"

  bottle do
    cellar :any
    sha1 "16c1a7476c1f43cfdee4b3410dc2a91b7c84ba5c" => :mavericks
    sha1 "e914e384c50f1fcde334f4ea059c62305b5e60ca" => :mountain_lion
    sha1 "be83fc32071b02e3881a67119e3944166d8f81ad" => :lion
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

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    cp_r "#{doc}/examples", testpath
    system "make", "-C", "examples"
  end
end
