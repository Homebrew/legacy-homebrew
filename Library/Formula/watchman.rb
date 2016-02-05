class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v4.4.0.tar.gz"
  sha256 "6fdd830584e59d0c70d06c5776d3ab68eb0cfe81ec2c071455bf04df84d9aee2"
  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 "51a61b12a16b9fc67670c54f925c1ff4fb7e5b6f367680d88720cccf7dca63ae" => :el_capitan
    sha256 "f45f5355799b5a5c0936dda4f8d5918f324a593a7a16d04ad91490f375ac409a" => :yosemite
    sha256 "962d353385d05c4e88b035cad67697327439080dd41127b834f956504aed418f" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pcre"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre",
                          # we'll do the homebrew specific python
                          # installation below
                          "--without-python"
    system "make"
    system "make", "install"

    # Homebrew specific python application installation
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    cd "python" do
      system "python", *Language::Python.setup_install_args(libexec)
    end
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    list = shell_output("#{bin}/watchman -v")
    if list.index(version).nil?
      raise "expected to see #{version} in the version output"
    end
  end
end
