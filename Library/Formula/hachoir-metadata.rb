class HachoirMetadata < Formula
  desc "Extract metadata from video, music and other files"
  homepage "https://bitbucket.org/haypo/hachoir/wiki/Home"
  url "https://cheeseshop.python.org/packages/source/h/hachoir-metadata/hachoir-metadata-1.3.3.tar.gz"
  sha256 "ec403f13a44e2cf3d26001f8f440cdc4329a316a4c971035944bfadacc90eb3c"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "b2a11194217ff9b97338b9c10147fd25f3e83213d0579bc88cef9689895025a3" => :el_capitan
    sha256 "316c9a2496302aef88844f80b8c7f63f69dd991c1f183b46228636b4780c7d7a" => :yosemite
    sha256 "73c9aaf96521afa7bac1942ea16a5af6c0baaba1537c399c22e493ea24ae7186" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "hachoir-core" do
    url "https://cheeseshop.python.org/packages/source/h/hachoir-core/hachoir-core-1.3.3.tar.gz"
    sha256 "ecf5d16eccc76b22071d6062e54edb67595f70d827644d3a6dff04289b4058df"
  end

  resource "hachoir-parser" do
    url "https://cheeseshop.python.org/packages/source/h/hachoir-parser/hachoir-parser-1.3.4.tar.gz"
    sha256 "775be5e10d72c6122b1ba3202dfce153c09ebcb60080d8edbd51aa89aa4e6b3f"
  end

  resource "hachoir-regex" do
    url "https://cheeseshop.python.org/packages/source/h/hachoir-regex/hachoir-regex-1.0.5.tar.gz"
    sha256 "a35b2bb0ff11418230fffbb97605adba012bf65d2aba3e5e7d8295774d5ba986"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    output = shell_output("#{bin}/hachoir-metadata --mime #{test_fixtures("test.png")}")
    assert_match "image/png", output
  end
end
