require "formula"

class HachoirMetadata < Formula
  homepage "https://bitbucket.org/haypo/hachoir/wiki/Home"
  url "http://cheeseshop.python.org/packages/source/h/hachoir-metadata/hachoir-metadata-1.3.3.tar.gz"
  sha1 "6f44f2f15a5d24866636117901d0b870137d8af7"

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

    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]
    res = %w[hachoir-core hachoir-parser hachoir-regex]
    res.each do |r|
      resource(r).stage { system "python", *install_args }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    print "Testing hachoir-metadata version (#{version}) ... "
    output = `#{bin}/hachoir-metadata --version`
    puts "#{output.chomp}."
    assert output.include?(version), 'hachoir version error.'
    assert_equal 0, $?.exitstatus, 'exitstatus error.'

    print "Testing png file mime type ..."
    png_file_path = (testpath/'hachoir.png')
    png_file_path.write("\x89PNG\r\n\u001A\n\u0000\u0000\u0000\rIHDR\u0000\u0000\u0000\u0001\u0000\u0000\u0000\u0001\b\u0000\u0000\u0000\u0000:~\x9BU\u0000\u0000\u0000\tpHYs\u0000\u0000\v\u0013\u0000\u0000\v\u0013\u0001\u0000\x9A\x9C\u0018\u0000\u0000\u0000\atIME\a\xDE\a\u0019\u000F\u0001\a\xF7\xF2\xF0%\u0000\u0000\u0000\fiTXtComment\u0000\u0000\u0000\u0000\u0000\xBC\xAE\xB2\x99\u0000\u0000\u0000\nIDAT\b\xD7c\xF8\u000F\u0000\u0001\u0001\u0001\u0000\e\xB6\xEEV\u0000\u0000\u0000\u0000IEND\xAEB`\x82")
    output = `#{bin}/hachoir-metadata --mime #{png_file_path}`
    puts "#{output.chomp}."
    assert output.include?('image/png'), 'hachoir mime error.'
    assert_equal 0, $?.exitstatus, 'exitstatus error.'

    puts "Cleanup ..."
    rm png_file_path
  end
end
