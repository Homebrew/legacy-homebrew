require "formula"

class Ino < Formula
  homepage "http://inotool.org"
  url "https://pypi.python.org/packages/source/i/ino/ino-0.3.6.tar.gz"
  sha1 "73fc512ce005d85d6aec5d910d68d6bf8c0f3b26"

  depends_on "picocom"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.2.1.tar.gz"
    sha1 "caadac82aa2576d6b445058c1fcf6ef0b14dbaa1"
  end

  resource "ordereddict" do
    url "https://pypi.python.org/packages/source/o/ordereddict/ordereddict-1.1.tar.gz"
    sha1 "ab90b67dceab55a11b609d253846fa486eb980c4"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.5.tar.gz"
    sha1 "a3a1dbe1444932b7c87e4c35fe6f64cf029d9559"
  end

  resource "pyserial" do
    url "https://pypi.python.org/packages/source/p/pyserial/pyserial-2.7.tar.gz"
    sha1 "f15694b1bea9e4369c1931dc5cf09e37e5c562cf"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.7.2.tar.gz"
    sha1 "6ed970106d18e48b361b09c227dac83b4cc72f26"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha1 "cd5c22acf6dd69046d6cb6a3920d84ea66bdf62a"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha1 "25ab3881f0c1adfcf79053b58de829c5ae65d3ac"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    rm Dir["#{lib}/python2.7/site-packages/*.pth"]

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/ino", "--help"
  end
end
