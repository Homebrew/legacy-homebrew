require "formula"

class Flocker < Formula
  homepage "https://clusterhq.com"
  url "https://github.com/ClusterHQ/flocker/archive/0.1.0.tar.gz"
  sha1 "59f61aa85b44981fc3ea8ddb132628b9ee27d02e"

  depends_on :python

  def install
    ENV.prepend_create_path 'PYTHONPATH', lib/"python2.7/site-packages"

    system "python", "setup.py", "install",
           "--prefix=#{prefix}",
           "--install-scripts=#{bin}",
           "--install-data=#{libexec}"
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/flocker-deploy", "--version"
  end
end
