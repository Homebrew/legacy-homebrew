class EulerPy < Formula
  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://github.com/iKevinY/EulerPy/archive/v1.2.3.tar.gz"
  sha256 "d751d561caf6296ecc59bc77ec2fb0c81af1b045a117b8ea3334b6a948230bbb"

  head "https://github.com/iKevinY/EulerPy.git"

  bottle do
    cellar :any
    sha1 "0118e4251a9a41adfca4c5f4fce135540a26b201" => :yosemite
    sha1 "f6a07bb235eebadc38e3474bbaf025704ee2236d" => :mavericks
    sha1 "962c5651ae11c6a981b43c9fdb01c3a99d2f127e" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-4.0.tar.gz"
    sha256 "f49e03611f5f2557788ceeb80710b1c67110f97c5e6740b97edf70245eea2409"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"
    resource("click").stage do
      system "python", "setup.py", "install", "--prefix=#{libexec}",
             "--single-version-externally-managed", "--record=installed.txt"
    end

    ENV.prepend_create_path "PYTHONPATH", "#{lib}/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{prefix}",
           "--single-version-externally-managed", "--record=installed.txt"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/euler") do |stdin, stdout, _|
      stdin.write("\n")
      stdin.close
      assert_match 'Successfully created "001.py".', stdout.read
    end
    assert_equal 0, $?.exitstatus
  end
end
