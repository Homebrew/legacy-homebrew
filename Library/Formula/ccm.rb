require "formula"

class Ccm < Formula
  homepage "https://github.com/pcmanus/ccm"
  url "https://github.com/pcmanus/ccm/archive/ccm-1.1.tar.gz"
  sha1 "cb216c633f04cf1821bfafa7d1c1a2e73444f20e"

  head "https://github.com/pcmanus/ccm.git", :branch => :master

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha1 "1a2d5df8b31124573efb9598ec6d54767f3c4cd4"
  end

  def install
    resource("pyyaml").stage do
      system "python", "setup.py", "install", "--prefix=#{libexec}"
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    ENV["PYTHONPATH"] = "#{lib}/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"
    bin.env_script_all_files(libexec + "bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # We can't test CCM core functionality without a Cassandra node to talk to.
    # Instead, just make sure it runs.
    system "#{bin}/ccm -h 2>&1 | grep 'Usage:'"
  end
end
