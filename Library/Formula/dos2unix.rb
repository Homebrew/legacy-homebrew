class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "http://waterlan.home.xs4all.nl/dos2unix.html"
  url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.2.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/dos2unix/dos2unix/7.2.2/dos2unix-7.2.2.tar.gz"
  sha256 "9c23907296267fa4ea66e1ee03eb6f6229cf7b64968318d00a77076ae89c2612"

  bottle do
    sha256 "616b1396b9e1860b236adce47dbaa61a216eb5eb13dd9b32d29f351b4d8f0f81" => :yosemite
    sha256 "612be4a1be16c9e52736f8a05d9fbf43692eb7132bf3cd1a6cd5c7f37ce1ce85" => :mavericks
    sha256 "2bc7821ed30d3b4ba34885bcf4f0435e8838bb5f6aa16f145c0f5443fbab3062" => :mountain_lion
  end

  devel do
    url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.2.3-beta1.tar.gz"
    sha256 "59cea39b181913532bf9e9c234a142c15e330d5eee145cd6b90f54becd6ec27b"
  end

  depends_on "gettext"

  def install
    gettext = Formula["gettext"]
    system "make", "prefix=#{prefix}",
                   "CC=#{ENV.cc}",
                   "CPP=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "CFLAGS_OS=-I#{gettext.include}",
                   "LDFLAGS_EXTRA=-L#{gettext.lib} -lintl",
                   "install"
  end

  test do
    # write a file with lf
    path = testpath/"test.txt"
    path.write "foo\nbar\n"

    # unix2mac: convert lf to cr
    system "#{bin}/unix2mac", path
    assert_equal "foo\rbar\r", path.read

    # mac2unix: convert cr to lf
    system "#{bin}/mac2unix", path
    assert_equal "foo\nbar\n", path.read

    # unix2dos: convert lf to cr+lf
    system "#{bin}/unix2dos", path
    assert_equal "foo\r\nbar\r\n", path.read

    # dos2unix: convert cr+lf to lf
    system "#{bin}/dos2unix", path
    assert_equal "foo\nbar\n", path.read
  end
end
