require "formula"

class HachoirMetadata < Formula
  homepage "https://bitbucket.org/haypo/hachoir/wiki/Home"
  url "http://cheeseshop.python.org/packages/source/h/hachoir-metadata/hachoir-metadata-1.3.3.tar.gz"
  sha1 "6f44f2f15a5d24866636117901d0b870137d8af7"

  bottle do
    cellar :any
    sha1 "ec6cfcfab8086753ad2dbac9712065b47cc6756f" => :mavericks
    sha1 "5cf33ff05b0dbea792f1e8030a24ee550f4a59fa" => :mountain_lion
    sha1 "f828b984aa92ccd7d9c99b93a3c64732a02690d6" => :lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "hachoir-core" do
    url "http://cheeseshop.python.org/packages/source/h/hachoir-core/hachoir-core-1.3.3.tar.gz"
    sha1 "e1d3b5da7d57087c922942b7653cb3b195c7769f"
  end

  resource "hachoir-parser" do
    url "http://cheeseshop.python.org/packages/source/h/hachoir-parser/hachoir-parser-1.3.4.tar.gz"
    sha1 "8433e1598b1e8d9404e6978117a203775e68c075"
  end

  resource "hachoir-regex" do
    url "http://cheeseshop.python.org/packages/source/h/hachoir-regex/hachoir-regex-1.0.5.tar.gz"
    sha1 "98a3c7e8922f926fdb6c1dec92e093d75712eb3b"
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
    test_png = HOMEBREW_LIBRARY/"Homebrew/test/fixtures/test.png"
    output = `#{bin}/hachoir-metadata --mime #{test_png}`
    assert output.include?("image/png")
    assert_equal 0, $?.exitstatus
  end
end
