class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.36.1.tgz"
  sha256 "a2909e01e2f983179d63ef2094c42102c92c716032864e66ef25ae341ea28690"

  bottle do
    cellar :any
    sha1 "057993febf5b5b02d022e0b1a1b1e6d9dcee1702" => :mavericks
    sha1 "41b83f3a61169a73e3ce5c73f0c8f533dbf8161c" => :mountain_lion
    sha1 "a84965928a810a18f8dbac38091e4ab9a9e69214" => :lion
  end

  depends_on "openssl"
  depends_on "xz" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    args << "--without-lzma" << "--without-lzmadec" if build.without? "xz"

    system "./configure", *args
    system "make", "install"
    bash_completion.install Dir["misc/bash_completion.d/*"]
  end

  test do
    output = pipe_output("#{bin}/tarsnap -c --dry-run #{testpath} 2>&1")
    assert_match /Performing dry-run archival without keys/, output
  end
end
