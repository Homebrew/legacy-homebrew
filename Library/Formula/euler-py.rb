require "formula"

class EulerPy < Formula
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://github.com/iKevinY/EulerPy/archive/v1.2.3.tar.gz"
  sha1 "88d97d7807f6b06ebfe475eee31ebd021b4ef275"

  bottle do
    cellar :any
    sha1 "0118e4251a9a41adfca4c5f4fce135540a26b201" => :yosemite
    sha1 "f6a07bb235eebadc38e3474bbaf025704ee2236d" => :mavericks
    sha1 "962c5651ae11c6a981b43c9fdb01c3a99d2f127e" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-3.3.tar.gz"
    sha1 "d716a932b930d71059e49465b6b42e833808369a"
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
