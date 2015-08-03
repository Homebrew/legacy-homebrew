class HachoirMetadata < Formula
  desc "Extract metadata from video, music and other files"
  homepage "https://bitbucket.org/haypo/hachoir/wiki/Home"
  url "http://cheeseshop.python.org/packages/source/h/hachoir-metadata/hachoir-metadata-1.3.3.tar.gz"
  sha256 "ec403f13a44e2cf3d26001f8f440cdc4329a316a4c971035944bfadacc90eb3c"

  bottle do
    cellar :any
    sha1 "ec6cfcfab8086753ad2dbac9712065b47cc6756f" => :mavericks
    sha1 "5cf33ff05b0dbea792f1e8030a24ee550f4a59fa" => :mountain_lion
    sha1 "f828b984aa92ccd7d9c99b93a3c64732a02690d6" => :lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "hachoir-core" do
    url "http://cheeseshop.python.org/packages/source/h/hachoir-core/hachoir-core-1.3.3.tar.gz"
    sha256 "ecf5d16eccc76b22071d6062e54edb67595f70d827644d3a6dff04289b4058df"
  end

  resource "hachoir-parser" do
    url "http://cheeseshop.python.org/packages/source/h/hachoir-parser/hachoir-parser-1.3.4.tar.gz"
    sha256 "775be5e10d72c6122b1ba3202dfce153c09ebcb60080d8edbd51aa89aa4e6b3f"
  end

  resource "hachoir-regex" do
    url "http://cheeseshop.python.org/packages/source/h/hachoir-regex/hachoir-regex-1.0.5.tar.gz"
    sha256 "a35b2bb0ff11418230fffbb97605adba012bf65d2aba3e5e7d8295774d5ba986"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix+"lib/python2.7/site-packages"

    ["hachoir-core", "hachoir-parser", "hachoir-regex"].each do |res|
      resource(res).stage do
        system "python", "setup.py", "install", "--prefix=#{libexec}"
      end
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    output = `#{bin}/hachoir-metadata --mime #{test_fixtures("test.png")}`
    assert output.include?("image/png")
    assert_equal 0, $?.exitstatus
  end
end
