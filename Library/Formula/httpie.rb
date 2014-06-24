require "formula"

class Httpie < Formula
  homepage "http://httpie.org"
  url "https://github.com/jakubroztocil/httpie/archive/0.8.0.tar.gz"
  sha1 "bfffe9d782a896ca57f3dafef3d02bf81a07e5a8"

  head "https://github.com/jakubroztocil/httpie.git"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-1.6.tar.gz"
    sha1 "53d831b83b1e4d4f16fec604057e70519f9f02fb"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec + "lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix + "lib/python2.7/site-packages"

    resource("pygments").stage { system "python", "setup.py", "install", "--prefix=#{libexec}"}

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    # These are now rolled into 1.6 and cause linking conflicts
    rm [
      Dir.glob("#{bin}/easy_install*"),
      "#{lib}/python2.7/site-packages/site.py",
      Dir.glob("#{lib}/python2.7/site-packages/*.pth")
      ]

    bin.env_script_all_files(libexec + "bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/http", "https://google.com"
  end
end
