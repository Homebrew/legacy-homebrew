class EulerPy < Formula
  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://github.com/iKevinY/EulerPy/archive/v1.2.3.tar.gz"
  sha256 "d751d561caf6296ecc59bc77ec2fb0c81af1b045a117b8ea3334b6a948230bbb"

  head "https://github.com/iKevinY/EulerPy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "914a6ad292704a5bcc8798a524c9613995a45bba30bbd38559e282b64a8bb027" => :el_capitan
    sha256 "cb5678aba9536bbc64c2a2cc6c6a0808b19d00f8f228099f415f6e4bdb7f4de6" => :yosemite
    sha256 "429bf72a785e8d4d7fd50d76364806998ef63e0ec4dd5df8352fb2b52db9eb83" => :mavericks
    sha256 "0751ec60117c432ce0cfd264442d3f8f9394ea876fb8f5b08c26fe8ffe831168" => :mountain_lion
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
