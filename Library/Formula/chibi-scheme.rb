require "formula"

class ChibiScheme < Formula
  homepage "http://code.google.com/p/chibi-scheme/"

  stable do
    url "http://abrek.synthcode.com/chibi-scheme-0.7.2.tgz"
    sha1 "337908635020bf354ec9bcb62f91e1bbe534ff23"
  end

  head "https://code.google.com/p/chibi-scheme/", :using => :hg

  bottle do
    sha1 "e5f0e061820123d56736261e3f04907bf5c63ce8" => :mavericks
    sha1 "fd04e7f93c4b5bcc416ace19d80f7766c41a3afe" => :mountain_lion
    sha1 "7111751abca30c0a77c8130bd87f082cea255bdd" => :lion
  end

  def install
    ENV.deparallelize

    # "make" and "make install" must be done separately
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = `#{bin}/chibi-scheme -mchibi -e "(for-each write '(0 1 2 3 4 5 6 7 8 9))"`
    assert_equal "0123456789", output
    assert_equal 0, $?.exitstatus
  end
end

