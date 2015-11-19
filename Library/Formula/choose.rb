class Choose < Formula
  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"

  head "https://github.com/geier/choose.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f719b2bd5d9e2ddd820054d82468c421b64b9241180b348de7054cc200529ab" => :el_capitan
    sha256 "9d9a580de75a6699a72d8e657f7bd010feb4d357abdc3f0268b2fb26e29a0ce6" => :yosemite
    sha256 "b0e918080b27d6df6b01d8a6105e23540817d058ef1678d00216f52aec1d63d4" => :mavericks
  end

  resource "urwid" do
    url "https://pypi.python.org/packages/source/u/urwid/urwid-1.2.1.tar.gz"
    sha256 "9b9b5dabb7df6c0f12e84feed488f9a9ddd5c2d66d1b7c7c087055720b87c68c"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    resource("urwid").stage do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    bin.install "choose"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # There isn't really a better test than that the executable exists
    # and is executable because you can't run it without producing an
    # interactive selection ui.
    File.executable?("#{bin}/choose")
  end
end
