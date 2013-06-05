require 'formula'

class Makepasswd < Formula
  depends_on 'docbook2x'

  homepage 'http://people.defora.org/~khorben/projects/makepasswd/'
  url 'http://people.defora.org/~khorben/projects/makepasswd/makepasswd-0.5.1.tar.gz'
  sha1 'bbb0a0d007aca9d47f456c8b2191d3ae23b3f37f'

  def install
    # makepasswd uses a straight forward Makefile (no autoconf, configure,
    # etc). The upstream project build has not been made configurable
    # (hardcoded LDFLAGS and PREFIX).  Build steps below circumvent that per
    # the project's homepage.

    system "make", "LDFLAGS="
    system "make", "install", "PREFIX=#{prefix}"

    # Upstream project uses db2man.sh script -- wasn't able to find much info
    # on this, plus the upstream doc Makefile expects only certain specific
    # tool locations. Working around it was simple enough to get the formula
    # working:

    docbook2man_bin = "#{HOMEBREW_PREFIX}/bin/docbook2man"

    cd "doc" do
      system "#{docbook2man_bin}", "makepasswd.1.xml"
      man1.install('MAKEPASSWD.1' => "makepasswd.1")
    end
  end

  test do
    # makepasswd has a default character set that matches this regex, and a
    # default passwd min/max length of 6/8. Run the test with `brew test makepasswd`.

    valid_pass_regex = /^[\w\d`~!@#\$%^&*()-=+]{6,8}$/

    # Passwords that can be generated, which should match regex:
    # raise unless "7q1#-_Ub" =~ valid_pass_regex
    # raise unless "7q1($%Ub" =~ valid_pass_regex

    raise unless `#{bin}/makepasswd`.strip =~ valid_pass_regex
  end
end
