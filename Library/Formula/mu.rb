require "formula"

class Emacs23Installed < Requirement
  fatal true
  env :userpaths
  default_formula "emacs"

  satisfy do
    `emacs --version 2>/dev/null` =~ /^GNU Emacs (\d{2})/
    $1.to_i >= 23
  end
end

class Mu < Formula
  homepage "http://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/archive/v0.9.11.tar.gz"
  sha1 "080b69bfb4876cb683acb961e8b71d6ebba90fa0"

  head "https://github.com/djcb/mu.git"

  bottle do
    revision 1
    sha1 "fa5412706e677fcc042e3e461e97cdc7e960185e" => :yosemite
    sha1 "42cc5427d5de000729c51f627bb00927606c2be9" => :mavericks
    sha1 "b7dda439293d64bdba9173318eeb381524cbdddb" => :mountain_lion
  end

  option "with-emacs", "Build with emacs support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmime"
  depends_on "xapian"
  depends_on Emacs23Installed if build.with? "emacs"

  env :std if build.with? "emacs"

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
    system "make install"
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
