class Diffoscope < Formula
  desc "In-depth comparison of files, archives, and directories."
  homepage "https://diffoscope.org"
  url "https://pypi.python.org/packages/source/d/diffoscope/diffoscope-42.tar.gz"
  sha256 "c0241acf5de7eb0e9e209e43dbf389beca722ddfb8b5d5630fd40569f1f465e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3da95ec12e2ceb498269d4cca444cc0a74c97ea9ba5dce7f0eafd12e55b2970" => :el_capitan
    sha256 "d11689783435f77d5e00c2b3477dee5189063c76359dc17528b59b9c7d793f60" => :yosemite
    sha256 "4c2c9c24fc2c7d02b0ddd5db7cf2f0f84d36df801b72e14a058d0b3ad9c76544" => :mavericks
  end

  depends_on "libmagic"
  depends_on "libarchive"
  depends_on "gnu-tar"
  depends_on :python3

  patch do
    url "https://anonscm.debian.org/cgit/reproducible/diffoscope.git/patch/?id=261be7"
    sha256 "aeaffa34a774e05477c9ef78df35174b006670b2963b9064c9c4c13484825b0b"
  end

  resource "libarchive-c" do
    url "https://pypi.python.org/packages/source/l/libarchive-c/libarchive-c-2.2.tar.gz"
    sha256 "5d54aa6f6ab21e3bd12c2f8b6c4e80316b049c2b60ab0a4418cb34d8c63e997c"
  end

  resource "python-magic" do
    url "https://pypi.python.org/packages/source/p/python-magic/python-magic-0.4.10.tar.gz"
    sha256 "79fd2865ec96074749825f9e9562953995d5bf12b6793f24d75c37479ad4a2c3"
  end

  def install
    inreplace "diffoscope/comparators/tar.py", "'tar'", "'gtar'"

    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{pyver}/site-packages"

    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    libarchive = Formula["libarchive"].opt_lib/"libarchive.dylib"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"],
                                            :LIBARCHIVE => libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "test1", "test2"
  end
end
