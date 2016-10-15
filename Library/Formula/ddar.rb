require "formula"

class Ddar < Formula
  homepage "http://www.synctus.com/ddar/"
  url "https://github.com/basak/ddar/archive/v1.0.tar.gz"
  sha1 "5f8b508f93031b1be217441b45fff27a6b630a49"

  head 'https://github.com/basak/ddar.git'

  depends_on 'xmltoman' => :build
  depends_on :python
  depends_on 'protobuf' => 'with-python'

  def install
    py_version = `python -c 'import sys; print "%i.%i" % (sys.version_info[0], sys.version_info[1])'`.chomp
    ENV['PYTHONPATH'] = HOMEBREW_PREFIX/"lib/python#{py_version}/site-packages"
    
    system "make", "-f", "Makefile.prep", "pydist"
    system "python", "setup.py", "install", "--prefix=#{prefix}", "--single-version-externally-managed", "--record=installed.txt"
    bin.env_script_all_files (libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
    man1.install Dir['*.1']
  end

  test do
    test_file = "test.out"
    test_ddar_file = "#{test_file}.ddar"
    (testpath/test_file).write "test"
    `"#{bin}/ddar" -c "#{test_ddar_file}" "#{test_file}"`
    extracted_file = `"#{bin}/ddar" -x "#{test_ddar_file}"`
    assert_equal File.read(test_file), extracted_file
  end
end
