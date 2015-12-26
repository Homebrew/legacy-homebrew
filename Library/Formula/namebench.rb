class Namebench < Formula
  desc "DNS benchmark utility"
  homepage "https://code.google.com/p/namebench/"
  url "https://namebench.googlecode.com/files/namebench-1.3.1-source.tgz"
  sha256 "30ccf9e870c1174c6bf02fca488f62bba280203a0b1e8e4d26f3756e1a5b9425"

  option "without-third-party", "Do not install bundled third-party modules"

  deprecated_option "no-third-party" => "without-third-party"

  def install
    ENV["NO_THIRD_PARTY"] = "1" if build.without? "third-party"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{libexec}",
                     "--install-data=#{libexec}/lib/python2.7/site-packages"

    bin.install "namebench.py" => "namebench"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/namebench", "--query_count", "1", "--only", "8.8.8.8"
  end
end
