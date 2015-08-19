class Pius < Formula
  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/v2.1.1.tar.gz"
  sha256 "9c33bf14361fafc39ba0fed072ef211251dd315e530e39ea4014957819c492ea"

  depends_on :gpg

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    # Replace hardcoded gpg path (WONTFIX):
    # https://sourceforge.net/p/pgpius/bugs/12/
    inreplace "libpius/constants.py", "/usr/bin/gpg", "#{HOMEBREW_PREFIX}/bin/gpg"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    The path to gpg is hardcoded in pius as #{HOMEBREW_PREFIX}/bin/gpg.
    You can specify a different path by editing ~/.pius:
      gpg-path=/path/to/gpg
    EOS
  end

  test do
    system "#{bin}/pius", "-T"
  end
end
