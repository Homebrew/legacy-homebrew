require 'formula'

class Makepasswd < Formula
  homepage 'http://people.defora.org/~khorben/projects/makepasswd/'
  url 'http://people.defora.org/~khorben/projects/makepasswd/makepasswd-0.5.1.tar.gz'
  sha1 'bbb0a0d007aca9d47f456c8b2191d3ae23b3f37f'

  def install
    # makepasswd uses a straight forward Makefile (no autoconf, configure,
    # etc). The upstream project build has not been made configurable
    # (hardcoded LDFLAGS and PREFIX).  Build steps below circumvent that per
    # the project's homepage.

    # TODO build and install man page

    system "make", "LDFLAGS="
    system "make", "install", "PREFIX=#{prefix}"
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
