class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/v2.6.tar.gz"
  sha256 "286b3285f096a5d249de1507eee88b14848514696bc5bbc4faceffa46b563ebd"

  bottle :unneeded

  depends_on "openssl"

  def install
    ENV.prepend_create_path "PATH", "#{Formula["openssl"].opt_prefix}"
    bin.install "testssl.sh"
    bin.env_script_all_files(libexec+"bin", :PATH => ENV["PATH"])
  end

  test do
    system "#{bin}/testssl.sh", "--local"
  end
end
