class Pssh < Formula
  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/p/parallel-ssh/"
  url "https://parallel-ssh.googlecode.com/files/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"

  conflicts_with "putty", :because => "both install `pscp` binaries"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"

    system "python", "setup.py", "install",
      "--prefix=#{prefix}", "--install-data=#{share}"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/pssh", "--version"
  end
end
