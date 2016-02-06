class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v4.4.0.tar.gz"
  sha256 "6fdd830584e59d0c70d06c5776d3ab68eb0cfe81ec2c071455bf04df84d9aee2"
  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 "65f94ea23b94f29ac7cfa04bc501cec9f2b65dcc3771b48a5afdce579ba6104d" => :el_capitan
    sha256 "d591c272ba779623bc47374b5142636ff6864b01a806c2ac298610b7f2b575e9" => :yosemite
    sha256 "8da996bdf96d7d8f1c37240c855677a9cc687311e3ee150a6628547909bad531" => :mavericks
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
