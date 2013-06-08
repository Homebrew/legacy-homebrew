require 'formula'

class Blast < Formula
  homepage ''
  url 'ftp://ftp.ncbi.nlm.nih.gov/blast/executables/release/2.2.22/blast-2.2.22-universal-macosx.tar.gz'
  sha1 'cc3755d945cbd4375b3e0f7212945229605f8b68'

  def install
    raise "#{ENV['HOME']}/.ncbirc already exists, delete or move for proper installation" if File.exists?("#{ENV['HOME']}/.ncbirc")
    prefix.install Dir['*']
    cd(ENV['HOME']) do
      File.open(".ncbirc", "w") do |f|     
        f.write('[NCBI]')   
        f.write("Data=#{HOMEBREW_PREFIX}/Cellar/#{name}/#{version}/data/")   
      end
    end
  end

  test do
    version = `blastall | head -n 2 | tail -n 1`
    version.include?('blastall 2.2.22') ? true : false
  end
end