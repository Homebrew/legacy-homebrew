class Uftp < Formula
  desc "Encrypted multicast file transfer."
  homepage "http://uftp-multicast.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-4.9.tar.gz"
  sha256 "5ed7332ec72bc6d0b19d3045ee432bf29d427389d0b711c306fa41ce2cb963e6"

  depends_on "openssl"

  def install
    system "sed", "-i.bak", "s_/usr/_/_g", "makefile"
    system "make", "install",
                   "DESTDIR=#{prefix}",
                   "OPENSSL=#{Formula["openssl"].opt_prefix}"
  end

  test do
    assert_match /list_file/, shell_output("#{bin}/uftp -h 2>&1", 1)
    assert_match /list_file/, shell_output("#{sbin}/uftpd -h 2>&1", 1)

    genout= shell_output("#{bin}/uftp_keymgt -g ec:secp521r1  test-ec.key 2>&1")
    checkout= shell_output("#{bin}/uftp_keymgt   test-ec.key 2>&1")
    assert_equal(genout, checkout)
  end
end
