# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class ApacheDrill < Formula
  homepage ""
  url "http://getdrill.org/drill/download/apache-drill-0.9.0.tar.gz"
  version "0.9.0"
  sha256 "1680b4b937d26623f0f01d7719b0809decf3341f445f5caea3feed1ecbc16c4d"


  def install
    libexec.install Dir["*"]
    ["drill_dumpcat", "runbit", "sqlline"].each do |bin_file| 
      bin.write_exec_script Dir["#{libexec}/bin/#{bin_file}"]
    end
  end

  test do
    system "#{bin}/sqlline <<< 'SELECT * FROM cp.`employee.json`;'"
  end
end
