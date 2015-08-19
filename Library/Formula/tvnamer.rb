class Tvnamer < Formula
  desc "Automatic TV episode file renamer that uses data from thetvdb.com"
  homepage "https://github.com/dbr/tvnamer"
  url "https://github.com/dbr/tvnamer/archive/2.3.tar.gz"
  sha256 "c28836f4c9263ee8ad6994788ad35f00e66fa1bd602e876364cd9b938f2843c8"
  head "https://github.com/dbr/tvnamer.git"

  bottle do
    cellar :any
    sha256 "e2054cad544e9a1bc8d4eb7925c33909d126efaa7cb79a63d58e655a9d5b6e7d" => :yosemite
    sha256 "ccbdd91361cf82fa43718a3aa43291901d7ec26864a03422b47dbb0d6ebcf71c" => :mavericks
    sha256 "a055ef2f5c60a5e0ae4207ad85db4b9c6c961c0b0bea74505ebd47e1d331b32a" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "tvdb_api" do
    url "https://pypi.python.org/packages/source/t/tvdb_api/tvdb_api-1.10.tar.gz"
    sha256 "308e73a16fc79936f1bf5a91233cce6ba5395b3f908ac159068ce7b1fc410843"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[tvdb_api].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    raw_file = "brass.eye.s01e01.avi"
    expected_file = "Brass Eye - [01x01] - Animals.avi"
    touch testpath/"#{raw_file}"
    system "#{bin}/tvnamer", "-b", testpath/"#{raw_file}"
    File.exist? testpath/"#{expected_file}"
  end
end
