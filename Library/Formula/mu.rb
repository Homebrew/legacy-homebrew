class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "http://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/archive/0.9.15.tar.gz"
  sha256 "60c63fdf1b726696cb0028b86eaee2aa72e171493b2d5626ea173b912ff25d4c"
  head "https://github.com/djcb/mu.git"

  bottle do
    sha256 "58843a9fa75b7ab59618b99b98cb5106393b81c377f88541fee23b341d987702" => :el_capitan
    sha256 "2f85daec392f24260d7d87ba4c67ecb9223c89751665b60762cbb46ac21b2a7a" => :yosemite
    sha256 "1e355cb0ce355ba7b78debbaec8830d083c0c7332448189945acd62b0a0f2b43" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmime"
  depends_on "xapian"
  depends_on :emacs => ["23", :optional]

  def install
    # Explicitly tell the build not to include emacs support as the version
    # shipped by default with Mac OS X is too old.
    ENV["EMACS"] = "no" if build.without? "emacs"

    # https://github.com/djcb/mu/issues/380
    # https://github.com/djcb/mu/issues/332
    ENV.O0 if MacOS.version >= :mavericks && ENV.compiler == :clang

    system "autoreconf", "-ivf"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Existing mu users are recommended to run the following after upgrading:

      mu index --rebuild
    EOS
  end

  test do
    mkdir (testpath/"cur")

    (testpath/"cur/1234567890.11111_1.host1!2,S").write <<-EOS.undent
      From: "Road Runner" <fasterthanyou@example.com>
      To: "Wile E. Coyote" <wile@example.com>
      Date: Mon, 4 Aug 2008 11:40:49 +0200
      Message-id: <1111111111@example.com>

      Beep beep!
    EOS

    (testpath/"cur/0987654321.22222_2.host2!2,S").write <<-EOS.undent
      From: "Wile E. Coyote" <wile@example.com>
      To: "Road Runner" <fasterthanyou@example.com>
      Date: Mon, 4 Aug 2008 12:40:49 +0200
      Message-id: <2222222222@example.com>
      References: <1111111111@example.com>

      This used to happen outdoors. It was more fun then.
    EOS

    system "#{bin}/mu", "index",
                        "--muhome",
                        testpath,
                        "--maildir=#{testpath}"

    mu_find = "#{bin}/mu find --muhome #{testpath} "
    find_message = "#{mu_find} msgid:2222222222@example.com"
    find_message_and_related = "#{mu_find} --include-related msgid:2222222222@example.com"

    assert_equal 1, shell_output(find_message).lines.count
    assert_equal 2, shell_output(find_message_and_related).lines.count,
                 "You tripped over https://github.com/djcb/mu/issues/380\n\t--related doesn't work. Everything else should"
  end
end
