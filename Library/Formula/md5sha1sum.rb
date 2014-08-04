require 'formula'

class Md5sha1sum < Formula
  homepage 'http://www.microbrew.org/tools/md5sha1sum/'
  url 'http://www.microbrew.org/tools/md5sha1sum/md5sha1sum-0.9.5.tar.gz'
  mirror "http://www.sourcefiles.org/Utilities/Console/M-P/md5sha1sum-0.9.5.tar.gz"
  sha1 '84a46bfd2b49daa0a601a9c55b7d87c27e19ef87'

  bottle do
    cellar :any
    sha1 "2f064d2390b9564b6c9d6b84623e2807dd031706" => :mavericks
    sha1 "0c5dee6e92679788df27d0e2f53f23bceaf21ed4" => :mountain_lion
    sha1 "11bae51a115c14688f7f57cf0903a829f8c28dde" => :lion
  end

  conflicts_with 'polarssl', :because => 'both install conflicting binaries'

  def install
    ENV["SSLINCPATH"] = "#{MacOS.sdk_path}/usr/include"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install 'md5sum'
    bin.install_symlink bin/'md5sum' => 'sha1sum'
    bin.install_symlink bin/'md5sum' => 'ripemd160sum'
  end

  test do
    (testpath/'file.txt').write('This is a test file with a known checksum')
    (testpath/'file.txt.sha1').write <<-EOS.undent
      52623d47c33ad3fac30c4ca4775ca760b893b963  file.txt
    EOS
    system "#{bin}/sha1sum", '--check', 'file.txt.sha1'
  end

end
