require "formula"

class Httpie < Formula
  homepage "http://httpie.org"
  url "https://github.com/jakubroztocil/httpie/archive/0.8.0.tar.gz"
  sha1 "bfffe9d782a896ca57f3dafef3d02bf81a07e5a8"

  head "https://github.com/jakubroztocil/httpie.git"

  bottle do
    cellar :any
    revision 1
    sha1 "22ddd11f67e37e7100ffd2e83cde865dbea86c5a" => :mavericks
    sha1 "c401847c644005c08879ccb6ff165b6509b91d0f" => :mountain_lion
    sha1 "c2b1509dad6a6bb8addca38292d152d2614e8aa9" => :lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-1.6.tar.gz"
    sha1 "53d831b83b1e4d4f16fec604057e70519f9f02fb"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.3.0.tar.gz"
    sha1 "f57bc125d35ec01a81afe89f97dc75913a927e65"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec + "lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix + "lib/python2.7/site-packages"

    install_args = "setup.py", "install", "--prefix=#{libexec}"
    resource("pygments").stage { system "python", *install_args }
    resource("requests").stage { system "python", *install_args }

    system "python", "setup.py", "install", "--prefix=#{libexec}"

    (bin/"http").write_env_script libexec/"bin/http", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    system "#{bin}/http", "https://google.com"
  end
end
