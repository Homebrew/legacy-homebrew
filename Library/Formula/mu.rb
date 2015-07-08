class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "http://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/archive/v0.9.12.tar.gz"
  sha256 "b871124fc7774a2593815f89286671a8f31d7243bb898a8ca454685599f2b9af"

  head "https://github.com/djcb/mu.git"

  bottle do
    sha256 "8166a3b3788068a97ceb81cb64cca24bd8b92ff3a1ece722e3a27a304979ea6f" => :yosemite
    sha256 "8c99800aa123e167c835d05024ac6a3efe435e7e4b05e8ddcc249c5a50805f74" => :mavericks
    sha256 "d59cf5dce157f19561f3a2575fb7f4498cd16668e1cee8ea28b80aecdc086428" => :mountain_lion
  end

  option "with-emacs", "Build with Emacs support (requires Emacs 23 or higher)"

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
