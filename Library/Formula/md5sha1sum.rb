class Md5sha1sum < Formula
  homepage "http://www.microbrew.org/tools/md5sha1sum/"
  url "http://www.microbrew.org/tools/md5sha1sum/md5sha1sum-0.9.5.tar.gz"
  mirror "http://www.sourcefiles.org/Utilities/Console/M-P/md5sha1sum-0.9.5.tar.gz"
  sha1 "84a46bfd2b49daa0a601a9c55b7d87c27e19ef87"

  bottle do
    cellar :any
    revision 1
    sha1 "bcc33c65f871406565ef2a6903ef8d710b5dbe13" => :yosemite
    sha1 "4336eec700ddbf54292291005fbd7bebbdf1d805" => :mavericks
    sha1 "e7908cb541f5b419978a71e2d0a443856e006b4c" => :mountain_lion
  end

  depends_on "openssl"

  conflicts_with "polarssl", :because => "both install conflicting binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "md5sum"
    bin.install_symlink bin/"md5sum" => "sha1sum"
    bin.install_symlink bin/"md5sum" => "ripemd160sum"
  end

  test do
    (testpath/"file.txt").write("This is a test file with a known checksum")
    (testpath/"file.txt.sha1").write <<-EOS.undent
      52623d47c33ad3fac30c4ca4775ca760b893b963  file.txt
    EOS
    system "#{bin}/sha1sum", "--check", "file.txt.sha1"
  end

end
