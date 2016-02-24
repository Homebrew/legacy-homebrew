class Muttils < Formula
  desc "Provides utilities for use with console mail clients, eg. Mutt."
  homepage "https://bitbucket.org/blacktrash/muttils/"
  url "https://bitbucket.org/blacktrash/muttils/get/1.3.tar.gz"
  sha256 "c8b456b660461441de8927ccff7e9f444894d6550d0777ed7bd160b8f9caddbf"
  bottle do
    cellar :any
    sha256 "d976f7445a3142ff1c311cf19302b5fcc2976b0a26c0bb48e57e157bd4c7002f" => :yosemite
    sha256 "01f0c26274540336fa829a8718bb0c3a2a5b5aa3c96c1f4ec7cf79e6263b837b" => :mavericks
    sha256 "63e819c0bb96a56ed0f159ab816aeac84805a52333bd23298a17cd2abddcb17b" => :mountain_lion
  end

  head "https://bitbucket.org/blacktrash/muttils", :using => :hg

  depends_on :python if MacOS.version <= :snow_leopard

  conflicts_with "talk-filters", :because => "both install `wrap` binaries"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match /^foo\nbar\n$/, pipe_output("#{bin}/wrap -w 2", "foo bar")
  end
end
