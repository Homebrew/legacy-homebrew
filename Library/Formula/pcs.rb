class Pcs < Formula
  desc "The terminal utility for Baidu Network Disk."
  homepage "https://github.com/GangZhuo/BaiduPCS/"
  url "https://github.com/GangZhuo/BaiduPCS/archive/0.2.3.tar.gz"
  sha256 "e0a72e41560df3f1499cf5baf29404465d34b14a9bff82095335dd29f0a0216f"

  head "https://github.com/GangZhuo/BaiduPCS.git"

  depends_on "openssl"

  def install
    system "make", "clean"
    system "make"
    bin.install "bin/pcs"
  end

  def caveats; <<-EOS.undent
    The pcs is client of baidu net disk. It supplied many functions,
    which can manage baidu net disk on terminal, such as ls, cp, rm,
    mv, rename, download, upload, search and so on.

    The pcs provided AES encryption, which can protected your data.

    The pcs is open source, and published on MIT.
    Please see https://github.com/GangZhuo/baidupcs.

    To login with your Baidu account, run:
      pcs login

    To get help, run:
      pcs help
    EOS
  end

  test do
    system bin/"pcs", "version"
  end
end
