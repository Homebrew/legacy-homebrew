class Znapzend < Formula
  desc "zfs backup with remote capabilities and mbuffer integration"
  homepage "http://www.znapzend.org"
  url "https://github.com/oetiker/znapzend/releases/download/v0.15.3/znapzend-0.15.3.tar.gz"
  sha256 "27f7c218f4e71beac7b2ba52386a7742506d45c0b3fd40104f44ccef0f373b6e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee7bd50e5a2f15509cbd393d37deeef5bef96d234fe4d8b0342b737da4489b96" => :el_capitan
    sha256 "9090216f04ff5c5c71f17bdaa955b7ce3accc3e23fe5a3fb0a7468b35e2154cd" => :yosemite
    sha256 "499e13a3ecf75b3f912f30b280ad88c1108ad3e4f99972d40f7c24566aa89696" => :mavericks
  end

  depends_on "perl" if MacOS.version <= :mavericks

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    fake_zfs = testpath/"zfs"
    fake_zfs.write <<-EOS.undent
      #!/bin/sh
      for word in "$@"; do echo $word; done >> znapzendzetup_said.txt
      exit 0
    EOS
    chmod 0755, fake_zfs
    ENV.prepend_path "PATH", testpath
    system "#{bin}/znapzendzetup", "list"
    assert_equal <<-EOS.undent, (testpath/"znapzendzetup_said.txt").read
      list
      -H
      -o
      name
      -t
      filesystem,volume
    EOS
  end
end
