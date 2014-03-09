require 'formula'

class AardvarkShellUtils < Formula
  homepage 'http://www.laffeycomputer.com/shellutils.html'
  url 'http://downloads.laffeycomputer.com/current_builds/shellutils/aardvark_shell_utils-1.0.tar.gz'
  sha1 '8cee29059038ebec96c3a97978d18a5a4941da06'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end

  test do
    output = `#{bin}/filebase movcpm.com`
    assert_equal "movcpm\n", output
    assert_equal 0, $?.exitstatus

    output = `#{bin}/fileext movcpm.com`
    assert_equal "com\n", output
    assert_equal 0, $?.exitstatus

    output = `#{bin}/realpath .`
    assert_equal "#{testpath}\n", output
    assert_equal 0, $?.exitstatus
  end
end
