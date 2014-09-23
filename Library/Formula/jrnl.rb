require "formula"

class Jrnl < Formula
  homepage "http://maebert.github.io/jrnl/"
  url "https://github.com/maebert/jrnl/archive/1.9.6.tar.gz"
  sha1 "925571cd9ba85803a291d0a0816dbf79882e45dd"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.tar.gz"
    sha1 "c17e41a80b3fbf2ee4e8f2d8bb9e28c5d08bbb84"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/python2.7/site-packages"
    resource("pycrypto").stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }

    ENV.prepend_create_path "PYTHONPATH", "#{lib}/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{prefix}"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/jrnl", "-v"
    assert_equal 0, $?.exitstatus
  end
end
